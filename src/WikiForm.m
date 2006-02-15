(*******************************************************************
This file was generated automatically by the Mathematica front end.
It contains Initialization cells from a Notebook file, which
typically will have the same name as this file except ending in
".nb" instead of ".m".

This file is intended to be loaded into the Mathematica kernel using
the package loading commands Get or Needs.  Doing so is equivalent
to using the Evaluate Initialization Cells menu command in the front
end.

DO NOT EDIT THIS FILE.  This entire file is regenerated
automatically each time the parent Notebook file is saved in the
Mathematica front end.  Any changes you make to this file will be
overwritten.
***********************************************************************)





BeginPackage["KnotTheory`WikiForm`",{"KnotTheory`"}];

NotHyperbolic;

WikiForm::usage="ToString[expression_,WikiForm] attempts to format expression in a manner suitable for a MediaWiki wiki. This is a strange kludge of html and pseudo-latex, particularly for long polynomials. It's not perfect, but not a disaster either.";

Begin["`Private`"]





WikiForm/:ToString[a_Integer,WikiForm]:=ToString[a]

WikiForm/:ToString[a_?NumberQ,WikiForm]:=ToString[a]

WikiForm /: ToString["", WikiForm] :=""

WikiForm/:ToString[WikiForm[S_String],WikiForm]:=S

WikiTextQ[
    S_String]:=!(StringFreeQ[
        S,{"<table","<tr","<td","{|","|-","|+","|}","{{"~~__~~"}}","[["~~__~~"]]",
          "http://"}])

WikiForm /: ToString[s_String, WikiForm] := If[WikiTextQ[s],s,
    StringReplace[
      "<nowiki>"<>s<>"</nowiki>",
      {"|" \[Rule] "&#124;"}
      ]
    ]

WikiForm/:ToString[K_Knot,WikiForm]:=NameString[K]
WikiForm/:ToString[L_Link,WikiForm]:=NameString[L]
WikiForm/:ToStirng[T_TorusKnot,WikiForm]:=NameString[T]

WikiForm/:ToString[Null,WikiForm]="";

MathTags[s_String]:="<math>"<>s<>"</math>"



listToString[{},s_String]:=""

listToString[x_List,s_String]:=
  StringJoin[Drop[Flatten[Transpose[{ToString/@x,Table[s,{Length[x]}]}]],-1]]

WikiForm/:ToString[gc_GaussCode,WikiForm]:=listToString[List@@gc,", "]

WikiForm/:ToString[dtc_DTCode,WikiForm]:=
  If[Length[dtc]\[Equal]0,"",listToString[List@@dtc," "]]

WikiForm/:ToString[NotAvailable,WikiForm]="";
WikiForm/:ToString[_NotAvailable,WikiForm]="";

WikiForm/:ToString[X[i_,j_,k_,l_],WikiForm]:=
  Module[{i1=ToString[i],j1=ToString[j],k1=ToString[k],l1=ToString[l]},
    If[{1,1,1,1}\[Equal]StringLength/@{i1,j1,k1,l1},
      ToString[StringForm["X<sub>````````</sub>",i1,j1,k1,l1]],
      ToString[StringForm["X<sub>``,``,``,``</sub>",i1,j1,k1,l1]]]]

WikiForm/:ToString[pd_PD,WikiForm]:=
  StringJoin@@Table[ToString[pd[[i]],WikiForm]<>" ",{i,Length[pd]}]



SymmetryType["Reversible"]=Reversible;
SymmetryType["Fully amphicheiral"]=FullyAmphicheiral;
SymmetryType["Negative amphicheiral"]=NegativeAmphicheiral;
SymmetryType["Chiral"]=Chiral;

WikiForm/:ToString[Reversible,WikiForm]="Reversible";
WikiForm/:ToString[FullyAmphicheiral,WikiForm]="Fully amphicheiral";
WikiForm/:ToString[NegativeAmphicheiral,WikiForm]="Negative amphicheiral";
WikiForm/:ToString[Chiral,WikiForm]="Chiral";

WikiForm/:ToString[_SymmetryType,WikiForm]="";
WikiForm/:ToString[_UnknottingNumber,WikiForm]="";
WikiForm/:ToString[_ThreeGenus,WikiForm]="";
WikiForm/:ToString[_BridgeIndex,WikiForm]="";
WikiForm/:ToString[_SuperBridgeIndex,WikiForm]="";
WikiForm/:ToString[_NakanishiIndex,WikiForm]="";

WikiForm/:ToString[NotHyperbolic,WikiForm]="Not hyperbolic";



WikiForm/:ToString[poly_?LaurentPolynomialQ,WikiForm]:=
  MathTags[StringReplace[ToString[poly,TeXForm],
      LaurentPolynomialTeXReplacementRule]]



WikiTeXForm/:ToString[a_,WikiTeXForm]:=
  StringReplace[ToString[a,TeXForm],"\\text{"\[Rule]"\\textrm{"]

WikiForm/:ToString[a_,WikiForm]:=MathTags[ToString[a,WikiTeXForm]]



\!\(\(PowerQ[_Integer] := True;\)\[IndentingNewLine]
  \(PowerQ[_\^_Integer] = True;\)\[IndentingNewLine]
  \(PowerQ[_Symbol] = True;\)\[IndentingNewLine]
  \(PowerQ[_] = False;\)\)



MonomialQ[x_Times]:=And@@(PowerQ/@List@@x)

MonomialQ[x_]:=PowerQ[x]

SplitMonomial[x_?MonomialQ]:=If[MatchQ[x,_Times],List@@x,{x}]

MonomialStringQ[x_String]:=
  MonomialQ[
    ToExpression[StringReplace[x,{"{"\[Rule]"(","}"\[Rule]")"}],InputForm]]

MonomialStringQ[_]:=False

\!\(PowerToString[x_?PowerQ] := x /. {k_Integer \[RuleDelayed] ToString[k] <> "\< \>", z_\^n_ \[RuleDelayed] ToString[z] <> "\<^{\>" <> ToString[n] <> "\<} \>", z_Symbol \[RuleDelayed] ToString[z]}\)

\!\(InvertMonomialString[x_?MonomialStringQ] := StringJoin @@ \((PowerToString /@ \(\((#\^\(-1\) &)\) /@ SplitMonomial[ToExpression[StringReplace[x, {"\<{\>" \[Rule] "\<(\>", "\<}\>" \[Rule] "\<)\>"}], InputForm]]\))\)\)

LaurentPolynomialQ[x_?MonomialQ]:=True
LaurentPolynomialQ[x_Plus]:=And@@(MonomialQ/@List@@x)

IfNotOne["1"]="";
IfNotOne[x_String]:=x

LaurentPolynomialTeXReplacementRule=
    "\\frac{"~~numerator:ShortestMatch[__]~~
          "}{"~~denominator:ShortestMatch[__]~~
              "}"~~rest:("+"|"-"|EndOfString)\[RuleDelayed]
      IfNotOne[numerator] ~~" "~~InvertMonomialString[denominator]~~rest;









End[]

EndPackage[]