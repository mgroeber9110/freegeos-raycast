include geos.def        ; standard macros
include resource.def    ; idata/udata, ProcCallFixedOrMovable etc.


XAUF = 240                              ; screen bitmap size
YAUF = 200

TEX_SIZE = 128                          ; texture size

OFF_LINES = XAUF/8                      ; bytes/line in offscreen bitmap
TEX_LINES = TEX_SIZE/8                  ; bytes/line if texture bitmap


global CLEAR_LINE_LOW:far
global GREY_LINE_LOW:far
global SCALE_LINE_LOW:far


                SetGeosConvention               ; set calling convention

ASM_TEXT        segment resource

;void clear_line_low(char *p,char mask,word hoehe)
;{
;    for(; hoehe; hoehe--,p+=sizeof(Offscreen.data[0]))
;      *p&=~mask;
;}
CLEAR_LINE_LOW  proc far _p:fptr, _mask:word, _hoehe:word
        uses    di
        .enter
                les di,_p               ; pointer into destination buffer
                mov ah,{byte}_mask      ; mask marking bits to clear
                not ah                  ; make it a "clear" mask
                mov cx,_hoehe           ; number of points to clear
clearloop:      and {byte}es:[di],ah    ; apply mask
                add di,OFF_LINES        ; advance one line
                loop clearloop          ; do until done
        .leave
        ret
CLEAR_LINE_LOW  endp

;void grey_line_low(char *p,char mask,word hoehe,word evenodd)
;{
;    for(; hoehe; hoehe--,p+=sizeof(Offscreen.data[0]),evenodd^=1)
;      if(evenodd)
;        *p&=~mask;
;      else
;        *p|=mask;
;}
GREY_LINE_LOW  proc far _p:fptr, _mask:word, _hoehe:word, _evenodd:word
        uses    di
        .enter
                les di,_p               ; pointer into destination buffer
                mov ah,{byte}_mask      ; mask marking bits to clear
                mov al,ah               ; we need a "set" and a "clear" mask
                not al                  ; make it a "clear" mask
                mov cx,_hoehe           ; number of points to clear
                mov bx,_evenodd         ; even/odd toggle
greyloop:       test bx,1
                je grey_set
                and {byte}es:[di],al    ; apply mask
                jmp short grey_cont
grey_set:       or  {byte}es:[di],ah    ; apply mask
grey_cont:      add di,OFF_LINES        ; advance one line
                xor bx,1                ; toggle black/white
                loop greyloop           ; do until done
        .leave
        ret
GREY_LINE_LOW  endp

;void scale_line_low(char *p,char mask,char *tp,char tmask,int ypos,word hoehe)
;{
;    int ylimit;
;    int error,c1,c2;                    ; Konstanten fÅr Bresenham
;
;     ; Bresenham scaling of wall texture: x <=> source, y <=> destination
;
;    ylimit = MIN(ypos+hoehe,YAUF)-MAX(ypos,0);
;
SCALE_LINE_LOW  proc far _p:fptr, _mask:word, _tp:fptr, _tmask:word, _ypos:sword, _hoehe:word
        uses    si,di
        .enter
                push    bp
                push    ds
                push    es

                ; compute ylimit (number of pixels in offscreen target bitmap)
                mov     dx,_ypos        ; MIN(ypos+hoehe,YAUF)
                add     dx,_hoehe
                cmp     dx,YAUF
                jl      sll_1
                  mov     dx,YAUF
sll_1:          mov     bx,_ypos        ; MAX(ypos,0)
                cmp     bx,0
                jge     sll_2
                  mov     bx,0
sll_2:          sub     dx,bx           ; MIN()-MAX()
                push    dx              ; (store ylimit for later use)

                mov     ah,{byte}_mask
                mov     al,{byte}_tmask
                lds     si,_tp
                les     di,_p

                cmp     _hoehe,TEX_SIZE
                ja      sll_enlarge

;    if(TEX_SIZE>=hoehe)                 ; reducing texture
;    {
;      c1 = 2 * hoehe;
;      error = c1 - (TEX_SIZE-1);
;      c2 = error - (TEX_SIZE-1);

                mov     cx,_hoehe       ; c1=2*hoehe
                add     cx,_hoehe
                mov     bx,cx           ; error=c1-(TEX_SIZE-1)
                sub     bx,(TEX_SIZE-1)
                mov     dx,bx           ; c2=error-(TEX_SIZE-1)
                sub     dx,(TEX_SIZE-1)

;      if(ypos<0)
;        while(ypos)
;        {
;          tp+=sizeof(texture[0]);
;          if(error < 0)                 ; Error ggf. erhîhen
;            error += c1;
;          else
;          {
;            ypos++;                     ; Auch Schritt nach "oben" (=Schirm)
;            error += c2;                ; Fehler vermerken.
;          }
;        }

                mov     bp,_ypos        ; no access to local vars from here on
sll_red_skip:   cmp     bp,0            ; no longer "above" screentop?
                jge     sll_red_endskip
                  add     si,TEX_LINES  ; tp+=sizeof()
                  cmp     bx,0          ; error<0 ?
                  jge     sll_red_1
                    add     bx,cx       ; yes: error+=c1
                    jmp     sll_red_skip
sll_red_1:        inc     bp            ; no: ypos++
                  add     bx,dx         ; error+=c2
                  jmp     sll_red_skip
sll_red_endskip:

;      while(ylimit)
;      {
;        tp+=sizeof(texture[0]);
;        if(error < 0)                   ; Error ggf. erhîhen
;          error += c1;
;        else
;        {
;          if( *tp & tmask )
;            *p|=mask;
;          else
;            *p&=~mask;
;          p+=sizeof(Offscreen.data[0]);
;          ylimit--;                     ; Auch Schritt nach "oben" (=Schirm)
;          error += c2;                  ; Fehler vermerken.
;        }
;      }
;    }

                pop     bp              ; get ylimit
sll_red_scale:  cmp     bp,0            ; copied all pixels
                je      sll_end
                  add     si,TEX_LINES  ; tp+=sizeof()
                  cmp     bx,0          ; error<0 ?
                  jge     sll_red_2
                    add     bx,cx       ; yes: error+=c1
                    jmp     sll_red_scale
sll_red_2:        test    ds:[si],al
                  je      sll_red_clear
                    or      es:[di],ah  ; set bit
                    jmp     short sll_red_cont
sll_red_clear:      not     ah
                    and     es:[di],ah  ; clear bit
                    not     ah
sll_red_cont:     add     di,OFF_LINES  ; p+=sizeof()
                  dec     bp            ; no: ylimit--
                  add     bx,dx         ; error+=c2
                  jmp     sll_red_scale

;    else                                ; enlarging texture
;    {
;      c1 = 2 * (TEX_SIZE-1);
;      error = c1 - hoehe;
;      c2 = error - hoehe;

sll_enlarge:    mov     cx,TEX_SIZE-1   ; c1=2*(TEX_SIZE-1)
                add     cx,TEX_SIZE-1
                mov     bx,cx           ; error=c1-hoehe
                sub     bx,_hoehe
                mov     dx,bx           ; c2=error-hoehe
                sub     dx,_hoehe

;      if(ypos<0)
;        while(ypos)
;        {
;          ypos++;                       ; Schritt nach "oben" (=auf Schirm)
;          if(error < 0)                 ; Error ggf. erhîhen
;            error += c1;
;          else
;          {
;            tp+=sizeof(texture[0]);
;            error += c2;                ; Fehler vermerken.
;          }
;        }

                mov     bp,_ypos        ; no access to local vars from here on
sll_enl_skip:   cmp     bp,0            ; no longer "above" screentop?
                jge     sll_enl_endskip
                  inc     bp            ; ypos++
                  cmp     bx,0          ; error<0 ?
                  jge     sll_enl_1
                    add     bx,cx       ; yes: error+=c1
                    jmp     sll_enl_skip
sll_enl_1:        add     si,TEX_LINES  ; no: tp+=sizeof()
                  add     bx,dx         ; error+=c2
                  jmp     sll_enl_skip
sll_enl_endskip:

;      while(ylimit)
;      {
;        if( *tp & tmask )
;          *p|=mask;
;        else
;          *p&=~mask;
;        p+=sizeof(Offscreen.data[0]);
;        ylimit--;                       ; Schritt nach "oben" (=auf Schirm)
;        if(error < 0)                   ; Error ggf. erhîhen
;          error += c1;
;        else
;        {
;          tp+=sizeof(texture[0]);
;          error += c2;                  ; Fehler vermerken.
;        }
;      }
;    }

                pop     bp              ; get ylimit
sll_enl_scale:  cmp     bp,0            ; copied all pixels
                je      sll_end
                  test    ds:[si],al
                  je      sll_enl_clear
                    or      es:[di],ah  ; set bit
                    jmp     short sll_enl_cont
sll_enl_clear:      not     ah
                    and     es:[di],ah  ; clear bit
                    not     ah
sll_enl_cont:     add     di,OFF_LINES  ; p+=sizeof()
                  dec     bp            ; no: ylimit--
                  cmp     bx,0          ; error<0 ?
                  jge     sll_enl_2
                    add     bx,cx       ; yes: error+=c1
                    jmp     sll_enl_scale
sll_enl_2:        add     si,TEX_LINES  ; tp+=sizeof()
                  add     bx,dx         ; error+=c2
                  jmp     sll_enl_scale
;}
sll_end:        pop     es
                pop     ds
                pop     bp
        .leave
        ret
SCALE_LINE_LOW  endp

ASM_TEXT        ends
