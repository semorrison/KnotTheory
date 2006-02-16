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





BeginPackage["KnotTheory`"];

Begin["`KTtoLinKnot`"]

checkArgs[s_,t_]:=
  ListQ[s]&&VectorQ[t,IntegerQ[#]&&#\[GreaterEqual]0&]&&
    Tr[t]\[LessEqual]Length[s]
iteratedTake[s_,t_]/;checkArgs[s,t]:=
  iteratedTake[s,t]=
    With[{w=FoldList[Plus,0,t]},
      Map[Take[s,#]&,Transpose[{Drop[w,-1]+1,Rest[w]}]]]

fContoKTGauss[Ul_String]:=Module[{mm,nn,ss,vv,i},
    mm=LinKnots`fGaussExtSigns[Ul];
    nn=LinKnots`fGaussExtSigns[StringReplace[Ul,"-"\[Rule]""]];
    nn=Map[Sign,Flatten[mm]]*Map[Sign,Flatten[nn]];
    vv=Table[nn[[i]]*(-1)^i,{i,Length[nn]}]*Abs[Flatten[mm]];
    ss=Map[Length,mm];
    mm=If[MemberQ[ss,0],{vv},iteratedTake[vv,ss]];
    GaussCode@@mm
    ]

PD[cn_ConwayNotation]:=PD[GaussCode[cn]]

InstallLinKnots::failed=
  "The function \"`1`\" requires the LinKnot package, which is not distributed as part of KnotTheory. I couldn't seem to load it; try downloading it from http://www.mi.sanu.ac.yu/vismath/linknot/, and adding the appropriate directory to the $Path."

InstallLinKnots[symbol_]:=Module[{oldContextPath=$ContextPath},
    (*Try to load LinKnots`*)
    Needs["LinKnots`"];
    (*If it failed, 
      it won't be on the $ContextPath. Try to give a useful error message.*)
    If[!MemberQ[$ContextPath,"LinKnots`"],
      Message[InstallLinKnots::failed,symbol];
      False,
      (*Now clean up the $ContextPath again, removing as much as possible.*)
      $ContextPath=oldContextPath;
      True
      ]
    ]

GaussCode[ConwayNotation[ss_String]]:=Module[{},
    If[InstallLinKnots[ConwayNotation],
      (GaussCode[ConwayNotation[ss0_String]]:=fContoKTGauss[ss0]);
      GaussCode[ConwayNotation[ss]],
      $Failed
      ]
    ]



End[]

EndPackage[]