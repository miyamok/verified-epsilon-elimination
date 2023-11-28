(load "~/minlog/init.scm")
(set! COMMENT-FLAG #f)
(libload "nat.scm")
(libload "list.scm")
(set! COMMENT-FLAG #t)

;; predicate
(add-alg "prd" '("nat=>prd" "Pvr") '("prd" "Falsum"))
(add-var-name "p" (py "prd"))
(add-totality "prd")

(add-program-constant "IsPvr" (py "prd=>boole"))
(add-computation-rules "IsPvr (Pvr n)" "True"
		       "IsPvr Falsum" "False")

(set-goal "Total IsPvr")
(assume "p^" "Tp")
(elim "Tp")
(assume "n^" "Tn")
(intro 0)
(intro 1)
(save-totality)

(add-algs "fla"
	  '("prd=>list alpha=>fla" "PrdFla")
	  '("fla=>fla=>fla" "ImpFla")
	  ;; '("fla=>fla=>fla" "CnjFla")
	  ;; '("fla=>fla=>fla" "DsjFla")
	  ;; '("var=>fla=>fla" "AllFla")
	  ;; '("var=>fla=>fla" "ExtFla")
	  )


(add-alg "cns" '("nat=>nat=>cns" "Cns"))
(add-totality "cns")

(add-var-name "c" (py "cns"))

(add-program-constant "IsCns" (py "cns=>boole"))

(add-computation-rules "IsCns (Cns n m)" "True")

(add-algs "trm"
	  '("nat=>trm" "VarTrm")
	  '("cns=>list trm=>trm" "CnsTrm")
	  ;;'("var=>fla trm=>trm" "EpsTrm")
	  )

(add-totality "fla")
(add-rtotality "fla")

(add-var-name "f" (py "fla trm"))
(add-var-name "fs" (py "list(fla trm)"))

(add-totality "trm")

(add-program-constant "IsFla" (py "fla trm=>boole"))
(add-program-constant "IsTrm" (py "trm=>boole"))

(add-var-name "t" (py "trm"))
(add-var-name "ts" (py "list trm"))

(add-computation-rules "IsTrm (VarTrm n)" "True"
		       "IsTrm (CnsTrm (Cns m n) ts)" "Lh ts=n")

(set-goal "Total IsTrm")
(assume "t^" "Tt")
(elim "Tt")
(assume "n^" "Tn")
;(elim "Tn")
(intro 0)
(assume "c^" "Tc" "ts^" "Tts")
(elim "Tc")
(assume "n^" "Tn" "m^" "Tm")
(elim "Tm")
(elim "Tts")
(intro 0)
(strip)
(intro 1)
(assume "n^0" "Tn0" "H")
(admit)
(save-totality)

(add-computation-rules
 "IsFla ((PrdFla trm)Falsum (Nil trm))" "False"
 "IsFla ((PrdFla trm)(Pvr n) ts)"
 "IsPvr (Pvr n) andb Lh ts=n andb ((Foldr boole boole)AndConst True (IsTrm map ts))"
 "IsFla  ((ImpFla trm)f f0)" "IsFla f andb IsFla f0"
 ;; "IsFla ((CnjFla trm)f f0)" "IsFla f andb IsFla f0"
 ;; "IsFla ((DsjFla trm)f f0)" "IsFla f andb IsFla f0"
 ;; "IsFla ((AllFla trm)var f)" "IsVar var andb IsFla f"
 ;; "IsFla ((ExtFla trm)var f)" "IsVar var andb IsFla f"
 )

;;(add-var-name "p" (py "pvr"))
(add-var-name "b" (py "boole"))

(add-program-constant "Kaxiom" (py "fla trm=>boole"))
(add-computation-rules
 "Kaxiom ((ImpFla trm) f ((ImpFla trm)f0 f1))" "f=f1"
 "Kaxiom ((ImpFla trm)f ((PrdFla trm)p ts))" "False"
 "Kaxiom ((PrdFla trm)p ts)" "False")

;;(pp (nt (pt "Kaxiom ((ImpFla trm) f ((ImpFla trm)f0 f))")))

(add-program-constant "Saxiom" (py "fla trm=>boole"))
(add-computation-rules
 "Saxiom ((ImpFla trm)((ImpFla trm)f((ImpFla trm)f0 f1))
                      ((ImpFla trm) ((ImpFla trm) f2 f3) ((ImpFla trm) f4 f5)))"
 "f=f2 andb f=f4 andb f0=f3 andb f1=f5"
 "Saxiom ((PrdFla trm)p ts)" "False"
 "Saxiom ((ImpFla trm)((ImpFla trm)f((PrdFla trm)p ts))
                      ((ImpFla trm) ((ImpFla trm) f2 f3) ((ImpFla trm) f4 f5)))"
 "False"
 "Saxiom ((ImpFla trm)((PrdFla trm)p ts)((ImpFla trm)
                      ((ImpFla trm) f2 f3) ((ImpFla trm) f4 f5)))"
 "False"
 "Saxiom ((ImpFla trm)f((ImpFla trm) ((ImpFla trm) f2 f3) ((PrdFla trm)p ts)))"
 "False"
 "Saxiom ((ImpFla trm)f((ImpFla trm)((PrdFla trm)p ts) ((ImpFla trm) f2 f3) ))"
 "False"
 "Saxiom ((ImpFla trm)f((PrdFla trm)p ts))" "False")

;;(pp (nt (pt "Saxiom ((ImpFla trm) f ((ImpFla trm)f0 f))")))

(add-program-constant "EFQ" (py "fla trm=>boole"))
(add-computation-rules "EFQ ((PrdFla trm)p ts)" "False"
		       "EFQ ((ImpFla trm)f f0)" "f=((PrdFla trm)Falsum(Nil trm))")
		       

(add-program-constant "MP" (py "fla trm=>fla trm=>boole"))
(add-computation-rules
 "MP ((ImpFla trm)f f0) f1" "f=f1"
 "MP ((PrdFla trm)p ts) f" "False")

(add-var-name "x" (py "alpha"))
(add-var-name "xs" (py "list alpha"))

(add-program-constant "Elem" (py "(alpha=>alpha=>boole)=>alpha=>list alpha=>boole"))
(add-computation-rules
 "(Elem alpha)(alpha=>alpha=>boole) x (Nil alpha)" "False"
 "(Elem alpha)(alpha=>alpha=>boole) x0 (x::xs)"
 "((alpha=>alpha=>boole) x0 x) orb ((Elem alpha)(alpha=>alpha=>boole) x0 xs)")

(add-program-constant "Ass" (py "list(fla trm)=>fla trm=>boole"))
(add-computation-rules
 "Ass fs f" "(Elem (fla trm))([f,f1]f=f1) f fs")

(pp (nt (pt "Kaxiom ((ImpFla trm)f ((ImpFla trm) f0 f1))")))


;; (set-goal "allnc b^, b^0(True eqd b^ andb b^0 -> b^ eqd True andnc b^0 eqd True)")
;; (assume "b^" "b^0" "H")
;; (assert "Total (b^ andb b^0)")
;; (simp "<-" "H")
;; (intro 0)
;; (simp "H")
;; (assume "H0")
;; (elim "H0")

;; (assert "b^ eqd True")

;; (set-goal "allnc b^, b^0(TotalBoole (b^ andb b^0) -> TotalBoole b^ andnc TotalBoole b^0 oru b^ eqd False oru b^0 eqd False)")
;; (assert "all b^1(TotalBoole b^1 -> allnc b^, b^0 (b^1 eqd b^ andb b^0 -> TotalBoole b^ andnc TotalBoole b^0 oru b^ eqd False oru b^0 eqd False))")
;; (assume "b^1" "Tb1")
;; (elim "Tb1")
;; (assume "b^" "b^0" "H")
;; (intro 0)
;; (intro 0)
;; (ng)

;; (set-goal "Total IsFla")
;; (assume "f^" "Tf")
;; (elim "Tf")
;; (intro 0)
;; (assume "p^"  "Tp" "ts^" "Tts")
;; (elim "Tp")
;; (assume "n^" "Tn")
;; (elim "Tn")
;; (elim "Tts")
;; (intro 0)
;; (assume "t^" "Tt" "ts^0" "Tts0" "H")
;; (intro 1)
;; (assume "n^0" "Tn0" "H")
;; (elim "Tts")
;; (intro 1)
;; (ng)
;; (elim "H")



;; (pt "(ImpFla trm)((ImpFla trm)f((ImpFla trm)f0 f1))")
;; (pt "((ImpFla trm) ((ImpFla trm) f2 f3) ((ImpFla trm) f4 f5))")
