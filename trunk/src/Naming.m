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





BeginPackage["KnotTheory`Naming`",{"KnotTheory`"}];

TorusKnots::usage="TorusKnots[n_] returns a list of all torus knots with up to n crossings.";

NameString::usage="NameString[K_] returns the 'standard' string name for the knot K. These names are used throughout the Knot Atlas, and can be reinterpreted simply using the function Knot. Thus NameString[Knot[7,2]] returns \"7_2\", and NameString[Knot[10,NonAlternating,124]] returns \"K10n124\".";

NextKnot::usage=PreviousKnot::usage="Use NextKnot and PreviousKnot to traverse lists of knots. These functions mostly exist to generate navigation links for the Knot Atlas.";

AlternatingQ::usage="AlternatingQ[K] tries to decide if the knot K is alternating. This function is extremely incomplete; it only works for named knots from the tables, or torus knots.";\

KnotNumber::usage="For a knot K from the tables, KnotNumber[K] returns its number in the appropriate sequence. Thus KnotNumber[Knot[8,19]] returns 19, while KnotNumber[Link[10,NonAlternating,5]] returns 5.";

Begin["`Private`"]

TorusKnots[Xmax_]:=Module[{res},
    res=Flatten[
        Table[Cases[Range[2,Min[Floor[1+Xmax/m],m-1]],
            n_/;GCD[m,n]\[Equal]1\[RuleDelayed]TorusKnot[m,n]],{m,3,Xmax}]];
    Last/@Sort[{Crossings[#],#}&/@res]
    ]

AlternatingQ[
      Knot[n_,k_]]/;(0\[LessEqual]n\[LessEqual]10\[And]1\[LessEqual]
          k\[LessEqual]NumberOfKnots[n]):=(k\[LessEqual]
      NumberOfKnots[n,Alternating])
AlternatingQ[Knot[_,Alternating,_]]:=True
AlternatingQ[Knot[_,NonAlternating,_]]:=False
AlternatingQ[Link[_,Alternating,_]]:=True
AlternatingQ[Link[_,NonAlternating,_]]:=False
AlternatingQ[TorusKnot[2,_]]:=True
AlternatingQ[TorusKnot[_,2]]:=True
AlternatingQ[TorusKnot[_,_]]:=False

KnotNumber[Knot[_,k_]]:=k
KnotNumber[Knot[_,_,k_]]:=k
KnotNumber[Link[_,_,k_]]:=k



NameString[
      Knot[n_Integer?(#\[LessEqual]10&),k_Integer]]/;(k\[LessEqual]
        NumberOfKnots[n]):=ToString[n]<>"_"<>ToString[k]

NameString[
      Knot[n_Integer?(#\[GreaterEqual]11&),Alternating,
        k_Integer]]/;(k\[LessEqual]NumberOfKnots[n,Alternating]):=
  "K"<>ToString[n]<>"a"<>ToString[k]

NameString[
      Knot[n_Integer?(#\[GreaterEqual]11&),NonAlternating,
        k_Integer]]/;(k\[LessEqual]NumberOfKnots[n,NonAlternating]):=
  "K"<>ToString[n]<>"n"<>ToString[k]

NameString[
      Link[n_Integer,Alternating,k_Integer]]/;(k\[LessEqual]
        NumberOfLinks[n,Alternating]):="L"<>ToString[n]<>"a"<>ToString[k]

NameString[
      Link[n_Integer,NonAlternating,k_Integer]]/;(k\[LessEqual]
        NumberOfLinks[n,NonAlternating]):="L"<>ToString[n]<>"n"<>ToString[k]

NameString[TorusKnot[m_Integer,n_Integer]]:=
  "T("<>ToString[m]<>","<>ToString[n]<>")"



Knot[S_String?(StringMatchQ[#,(DigitCharacter..)~~
                "_"~~(DigitCharacter..)]&)]/;((#\[LeftDoubleBracket]1\
\[RightDoubleBracket]\[LessEqual]10\[And]#\[LeftDoubleBracket]2\
\[RightDoubleBracket]\[LessEqual]
                NumberOfKnots[#\[LeftDoubleBracket]1\[RightDoubleBracket]])&[
        ToExpression/@StringSplit[S,"_"]]):=
  Knot@@(ToExpression/@StringSplit[S,"_"])

Knot[S_String?(StringMatchQ[#,
              "K"~~(DigitCharacter..)~~
                  "a"~~(DigitCharacter..)]&)]/;((#\[LeftDoubleBracket]1\
\[RightDoubleBracket]\[GreaterEqual]11\[And]#\[LeftDoubleBracket]2\
\[RightDoubleBracket]\[LessEqual]
                NumberOfKnots[#\[LeftDoubleBracket]1\[RightDoubleBracket],
                  Alternating])&[ToExpression/@StringSplit[S,{"K","a"}]]):=
  Knot[#\[LeftDoubleBracket]1\[RightDoubleBracket],
        Alternating,#\[LeftDoubleBracket]2\[RightDoubleBracket]]&[(\
ToExpression/@StringSplit[S,{"K","a"}])]

Knot[S_String?(StringMatchQ[#,
              "K"~~(DigitCharacter..)~~
                  "n"~~(DigitCharacter..)]&)]/;((#\[LeftDoubleBracket]1\
\[RightDoubleBracket]\[GreaterEqual]11\[And]#\[LeftDoubleBracket]2\
\[RightDoubleBracket]\[LessEqual]
                NumberOfKnots[#\[LeftDoubleBracket]1\[RightDoubleBracket],
                  NonAlternating])&[ToExpression/@StringSplit[S,{"K","n"}]]):=
  Knot[#\[LeftDoubleBracket]1\[RightDoubleBracket],
        NonAlternating,#\[LeftDoubleBracket]2\[RightDoubleBracket]]&[(\
ToExpression/@StringSplit[S,{"K","n"}])]

Knot[S_String?(StringMatchQ[#,
              "L"~~(DigitCharacter..)~~
                  "a"~~(DigitCharacter..)]&)]/;((1\[LessEqual]#\
\[LeftDoubleBracket]2\[RightDoubleBracket]\[LessEqual]
              NumberOfLinks[#\[LeftDoubleBracket]1\[RightDoubleBracket],
                Alternating])&[ToExpression/@StringSplit[S,{"L","a"}]]):=
  Link[#\[LeftDoubleBracket]1\[RightDoubleBracket],
        Alternating,#\[LeftDoubleBracket]2\[RightDoubleBracket]]&[(\
ToExpression/@StringSplit[S,{"L","a"}])]

Knot[S_String?(StringMatchQ[#,
              "L"~~(DigitCharacter..)~~
                  "n"~~(DigitCharacter..)]&)]/;((1\[LessEqual]#\
\[LeftDoubleBracket]2\[RightDoubleBracket]\[LessEqual]
              NumberOfLinks[#\[LeftDoubleBracket]1\[RightDoubleBracket],
                NonAlternating])&[ToExpression/@StringSplit[S,{"L","n"}]]):=
  Link[#\[LeftDoubleBracket]1\[RightDoubleBracket],
        NonAlternating,#\[LeftDoubleBracket]2\[RightDoubleBracket]]&[(\
ToExpression/@StringSplit[S,{"L","n"}])]

Knot[S_String?(StringMatchQ[#,
            "T("~~(DigitCharacter..)~~","~~(DigitCharacter..)~~")"]&)]:=
  TorusKnot[#\[LeftDoubleBracket]1\[RightDoubleBracket],#\[LeftDoubleBracket]\
2\[RightDoubleBracket]]&[(ToExpression/@StringSplit[S,{"T(",",",")"}])]



Knot[S_String?(StringMatchQ[#,(DigitCharacter..)~~
                "a_"~~(DigitCharacter..)]&)]/;((#\[LeftDoubleBracket]1\
\[RightDoubleBracket]\[GreaterEqual]11\[And]#\[LeftDoubleBracket]2\
\[RightDoubleBracket]\[LessEqual]
                NumberOfKnots[#\[LeftDoubleBracket]1\[RightDoubleBracket],
                  Alternating])&[ToExpression/@StringSplit[S,{"a_"}]]):=
  Knot[#\[LeftDoubleBracket]1\[RightDoubleBracket],
        Alternating,#\[LeftDoubleBracket]2\[RightDoubleBracket]]&[(\
ToExpression/@StringSplit[S,{"a_"}])]

Knot[S_String?(StringMatchQ[#,(DigitCharacter..)~~
                "n_"~~(DigitCharacter..)]&)]/;((#\[LeftDoubleBracket]1\
\[RightDoubleBracket]\[GreaterEqual]11\[And]#\[LeftDoubleBracket]2\
\[RightDoubleBracket]\[LessEqual]
                NumberOfKnots[#\[LeftDoubleBracket]1\[RightDoubleBracket],
                  NonAlternating])&[ToExpression/@StringSplit[S,{"n_"}]]):=
  Knot[#\[LeftDoubleBracket]1\[RightDoubleBracket],
        NonAlternating,#\[LeftDoubleBracket]2\[RightDoubleBracket]]&[(\
ToExpression/@StringSplit[S,{"n_"}])]



NextKnot[Knot[0,1]]=Knot[3,1];
NextKnot[Knot[n_Integer?(#\[LessEqual]10&),k_Integer]]/;(k<NumberOfKnots[n]):=
  Knot[n,k+1]
NextKnot[Knot[n_Integer?(#\[LessEqual]9&),k_Integer]]/;(k==NumberOfKnots[n]):=
  Knot[n+1,1]
NextKnot[Knot[10,k_Integer]]/;(k==NumberOfKnots[10]):=Knot[11,Alternating,1]

NextKnot[Knot[n_Integer?(#\[GreaterEqual]11&),t_,k_Integer]]/;(k<
        NumberOfKnots[n,t]):=Knot[n,t,k+1]
NextKnot[Knot[n_Integer?(#\[GreaterEqual]11&),Alternating,k_Integer]]/;(k==
        NumberOfKnots[n,Alternating]):=Knot[n,NonAlternating,1]
NextKnot[Knot[n_Integer?(#\[GreaterEqual]11&),NonAlternating,k_Integer]]/;(k==
        NumberOfKnots[n,NonAlternating]):=Knot[n+1,Alternating,1]

PreviousKnot[Knot[0,1]]=Knot[0,1];
PreviousKnot[Knot[3,1]]=Knot[0,1];
PreviousKnot[Knot[n_Integer?(#\[LessEqual]10&),1]]:=
  Knot[n-1,NumberOfKnots[n-1]]
PreviousKnot[Knot[n_Integer?(#\[LessEqual]10&),k_Integer]]:=Knot[n,k-1]

PreviousKnot[Knot[11,Alternating,1]]=Knot[10,NumberOfKnots[10]];
PreviousKnot[Knot[n_Integer?(#\[GreaterEqual]12&),Alternating,1]]:=
  Knot[n-1,NonAlternating,NumberOfKnots[n-1,NonAlternating]]
PreviousKnot[Knot[n_Integer?(#\[GreaterEqual]11&),NonAlternating,1]]:=
  Knot[n,Alternating,NumberOfKnots[n,Alternating]]
PreviousKnot[Knot[n_Integer?(#\[GreaterEqual]11&),t_,k_Integer]]:=
  Knot[n,t,k-1]

NextKnot[Last[AllLinks[]]]=Last[AllLinks[]];
PreviousKnot[Link[2,Alternating,1]]:=Link[2,Alternating,1];
NextKnot[L_Link]:=
  With[{all=AllLinks[]},
    all\[LeftDoubleBracket]Position[all,L]\[LeftDoubleBracket]1,
          1\[RightDoubleBracket]+1\[RightDoubleBracket]]
PreviousKnot[L_Link]:=
  With[{all=AllLinks[]},
    all\[LeftDoubleBracket]Position[all,L]\[LeftDoubleBracket]1,
          1\[RightDoubleBracket]-1\[RightDoubleBracket]]



PreviousKnot[TorusKnot[3,2]]=TorusKnot[3,2];

TorusKnotPosition[TorusKnot[m_,n_]]:=Module[{l=36},
    While[!MemberQ[TorusKnots[l],TorusKnot[m,n]],l+=36];
    Position[TorusKnots[l],TorusKnot[m,n]]\[LeftDoubleBracket]1,
      1\[RightDoubleBracket]
    ]

PreviousKnot[T_TorusKnot]:=
  TorusKnots[Crossings[T]]\[LeftDoubleBracket]
    TorusKnotPosition[T]-1\[RightDoubleBracket]

NextKnot[T_TorusKnot]:=Module[{p=TorusKnotPosition[T]+1,n=36},
    While[Length[TorusKnots[n]]<p,n+=36];
    TorusKnots[n]\[LeftDoubleBracket]p\[RightDoubleBracket]
    ]



End[]

EndPackage[]