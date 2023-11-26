(load "~/minlog/init.scm")
(set! COMMENT-FLAG #f)
(libload "nat.scm")
(libload "list.scm")
(set! COMMENT-FLAG #t)

(add-alg "var" '("nat=>var" "Var"))
(add-alg "cns" '("nat=>nat=>cns" "Cns"))
(add-alg "pvr" '("nat=>pvr" "Pvr"))

(add-totality "var")
(add-totality "cns")
(add-totality "pvr")

(add-program-constant "IsVar" (py "var=>boole"))
(add-computation-rules
 "IsVar (Var n)" "True")

(set-goal "Total IsVar")
(assume "var^" "Tv")
(elim "Tv")
(assume "n^" "Tn")
(intro 0)
(save-totality)

(add-program-constant "IsCns" (py "cns=>boole"))
(add-computation-rule "IsCns (Cns n m)" "True")

(set-goal "Total IsCns")
(assume "cns^" "Tc")
(elim "Tc")
(assume "n^" "Tn" "n^0" "Tn0")
(elim "Tn")
(elim "Tn0")
(intro 0)
(assume "n^1" "Tn1" "H")
(intro 0)
(assume "n^1" "Tn1" "H")
(intro 0)
(save-totality)

(add-program-constant "IsPvr" (py "pvr=>boole"))
(add-computation-rule "IsPvr (Pvr n)" "True")

(set-goal "Total IsPvr")
(assume "pvr^" "Tpvr")
(elim "Tpvr")
(assume "n^" "Tn")
(intro 0)

(add-algs '("trm" "fla")
	  '("var=>trm" "VarTrm")
	  '("cns=>list trm=>trm" "CnsTrm")
	  '("var=>fla=>trm" "EpsTrm")
	  '("fla" "BotFla")
	  '("pvr=>list trm=>fla" "PrdFla")
	  '("fla=>fla=>fla" "ImpFla")
	  '("fla=>fla=>fla" "CnjFla")
	  '("fla=>fla=>fla" "DsjFla")
	  '("var=>fla=>fla" "AllFla")
	  '("var=>fla=>fla" "ExtFla"))

(add-program-constant "IsTrm" (py "trm=>boole"))
(add-program-constant "IsFla" (py "fla=>boole"))

(add-program-constant "AllTrue" (py "list boole=>boole"))
(add-computation-rules
 "AllTrue (Nil boole)" "True"
 "AllTrue (True::(list boole))" "AllTrue (list boole)"
 "AllTrue (False::(list boole))" "False")

(set-goal "Total AllTrue")
(assume "list boole^" "Tlistboole")
(elim "Tlistboole")
(intro 0)
(assume "boole^" "Tb" "list boole^0" "Tlistboole0" "H")
(elim "Tb")
(use "H")
(intro 1)
(save-totality)

(add-computation-rules
 "IsTrm (VarTrm var)" "IsVar var"
 "IsTrm (CnsTrm cns (list trm))" "(IsCns cns) andb (AllTrue ((ListMap trm boole) IsTrm (list trm)))"
 "IsTrm (EpsTrm var fla)" "IsVar var andb IsFla fla"
 "IsFla (PrdFla pvr (list trm))" "IsPvr pvr andb (AllTrue ((ListMap trm boole) IsTrm (list trm)))"
 "IsFla (ImpFla fla fla0)" "IsFla fla andb IsFla fla0"
 "IsFla (CnjFla fla fla0)" "IsFla fla andb IsFla fla0"
 "IsFla (DsjFla fla fla0)" "IsFla fla andb IsFla fla0"
 "IsFla (AllFla var fla)" "IsVar var andb IsFla fla"
 "IsFla (ExtFla var fla)" "IsVar var andb IsFla fla")

;; (add-program-constant "EqTrm" (py "trm=>trm=>boole"))
;; (add-computation-rules
;;  "EqTrm (VarTrm (Var n)) (VarTrm (Var n0))"
;;  "n=n0"
;;  "EqTrm (CnsTrm (Cns n m) (list trm)) (CnsTrm (Cns n0 m0) (list trm_0))"
;;  "n=n0 andb m=m0 andb (list trm)=(list trm_0) andb (Lh (list trm) = Lh (list trm_0)) andb (Lh (list trm)=m"
;;  "EqTrm (EpsTrm var fla) (EpsTerm var0 fla0)" "
