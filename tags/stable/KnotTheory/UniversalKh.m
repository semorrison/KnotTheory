(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage["KnotTheory`UniversalKh`",{"KnotTheory`","QuantumGroups`Utilities`MatrixWrapper`"}];


UniversalKh::about="Universal Khovanov homology over Q[t] is calculated using Jeremy Green's JavaKh program, interpreted by a wrapper written by Dror Bar-Natan, and decomposed into direct summands using a program of Scott Morrison and Alexander Shumakovitch.";


UniversalKh::usage="UniversalKh[K] computes the universal Khovanov homology over Q. (Probably broken for links, at present.) See also KhC and KhE for more about the output.";


sInvariant::usage="sInvariant[K] computes the s-invariant of a knot K, using the UniversalKh program. (Probably broken for links, at present.)";


KhReduced::usage="KhReduced[K][q,t] gives the reduced Khovanov homology of the knot K, using the UniversalKh program.";


KhE::usage="KhE denotes a free generator in Khovanov homology, corresponding to an exceptional pair. See ?UniversalKh for more information."l
KhC::usage="KhC denotes a torsion generator in Khovanov homology, with the differential in KhC[n] being the n-th power of the punctured torus. Thus KhC[1] corresponds to a knight's move pair. See ?UniversalKh for more information."l


Begin["`Private`"]


q=Global`q;t=Global`t;


KhN[L_] :=KhN[L]= KhN[PD[L]];
KhN[pd_PD] := Module[
{n,pd1,  f, cl, out,kh,saveContext,saveContextPath,JavaKhDirectory,jarDirectory,classDirectory,classpath},
n=Max @@ (Max @@@ pd);
pd1 = pd /. {
X[n, i_, 1, j_] :> X[n, i, n+1, j],
X[i_, 1, j_, n] :> X[i, n+1, j, n],
X[1, j_, n, i_] :> X[n+1, j, n, i],
X[j_, n, i_, 1] :> X[j, n, i, n+1]
};
SetDirectory[ToFileName[KnotTheoryDirectory[],"JavaKh"]];
f=OpenWrite["pd",PageWidth->Infinity];
WriteString[f,ToString[pd1]];
Close[f];
JavaKhDirectory=ToFileName[KnotTheoryDirectory[],"JavaKh"];
jarDirectory=ToFileName[JavaKhDirectory,"jars"];
classDirectory=ToFileName[JavaKhDirectory,"bin"];classpath=StringJoin[(*this is a horrible hack to make sure the classpath works on both unix and windows systems*)classDirectory,":",ToFileName[jarDirectory,"commons-cli-1.0.jar"],":",ToFileName[jarDirectory,"commons-io-1.2.jar"],":",ToFileName[jarDirectory,"commons-logging-1.1.jar"],":",ToFileName[jarDirectory,"log4j-1.2.12.jar"],":;",classDirectory,";",ToFileName[jarDirectory,"commons-cli-1.0.jar"],";",ToFileName[jarDirectory,"commons-io-1.2.jar"],";",ToFileName[jarDirectory,"commons-logging-1.1.jar"],";",ToFileName[jarDirectory,"log4j-1.2.12.jar"]];cl=StringJoin["!java -classpath \"",classpath,"\" "," org.katlas.JavaKh.JavaKh -U < pd"];
f=OpenRead[cl];
out=Read[f,Expression];
Close[f];
ResetDirectory[];
If[out==EndOfFile,Print["Something went wrong running JavaKh; nothing was returned. The command line was: "];Print[cl];Return[$Failed]];
out=StringReplace[out,{"q"->"#1","t"->"#2"}];
(* ToExpression is dangerous! We have to fiddle with the $Context here. *)
saveContext=$Context;
saveContextPath=$ContextPath;
$Context="KnotTheory`UniversalKh`Private`";
$ContextPath={"KnotTheory`UniversalKh`Private`"};
kh=ToExpression[out<>"&"][q,t];
$Context=saveContext;
$ContextPath=saveContextPath;
minr=Exponent[kh, t, Min];
maxr=Exponent[kh, t, Max];
obs = Expand[kh /. h -> 0 /. M[_, n_, ___]  :> Plus @@ Array[Arc, n]];
obs = obs /. (q^j_.)*Arc[i_] :> Arc[j, i] /. Arc[i_] :> Arc[0, i];
mos= Expand[
h*kh /. {M[0,_]-> 0, M[_, 0] -> 0, h-> H}
/. M[m_, n_, cs___] :> Plus @@ Flatten[MapIndexed[
(#1*Curtain@@Reverse[#2])&,
Partition[{cs}, n],
{2}
]]
];
mos = mos /. (q^j_.)*Curtain[k_, l_] :> Curtain[j, k, l] /. Curtain[k_, l_] :> Curtain[0, k, l];
mos = mos /. (H^g_.)*Curtain[j_, k_, l_] :> H^(g-1)Curtain[j, k, j+2(g-1), l];
Komplex @@ Table[{r, Coefficient[obs, t, r],  Coefficient[mos, t, r]}, {r, minr, maxr}]
]


ElementaryMatrix[m_,n_,i_,j_]:=ElementaryMatrix[m,n,i,j,1]


ElementaryMatrix[m_,n_,i_,j_,z_]/;1<=i<=m\[And]1<=j<=n:=
Module[{data},
data=Table[0,{m},{n}];
data[[i,j]]=z;
Matrix[data]
]


GradingsList[k:Komplex[{n_,_,_},___]]:={n,Cases[{#},Arc[m_,_]:>m,2]&/@(List@@k)[[All,2]]}


Matrices[k:Komplex[{n_,_,_},___]]:={n,
Module[{gradings=GradingsList[k][[2]],dimensions},
dimensions=Length/@gradings;
Table[
ZeroesMatrix[dimensions[[i+1]],dimensions[[i]]]+
k[[i,3]]/.(Curtain[q1_,m1_,q2_,m2_]:>ElementaryMatrix[dimensions[[i+1]],dimensions[[i]],Position[gradings[[i+1]],q2][[1,1]]+m2-1,Position[gradings[[i]],q1][[1,1]]+m1-1])
,{i,1,Length[k]-1}]
]/.{H->T}
}


ZeroVector[n_]:=Table[0,{n}]


Matrix/:\[Alpha]_ Matrix[j_,k_,data_]/;(NumberQ[\[Alpha]/.T->3.14159`]):=Matrix[j,k,\[Alpha] data]


FirstRow[Matrix[r_,c_,data_]]:=Matrix[1,c,{First[data]}]
FirstRow[Matrix[0,c_,_]]:=Matrix[0,c]
FirstColumn[Matrix[r_,c_,data_]]:=Matrix[r,1,{First[#]}&/@data]
FirstColumn[Matrix[r_,0,_]]:=Matrix[r,0]
RestColumns[Matrix[r_,c_,data_]]:=Matrix[r,c-1,Rest/@data]
RestColumns[Matrix[r_,0|1,_]]:=Matrix[r,0]
RestRows[Matrix[r_,c_,data_]]:=Matrix[r-1,c,Rest[data]]
RestRows[Matrix[0|1,c_,_]]:=Matrix[0,c]


RotateRows[Matrix[r_,c_,data_]]:=Matrix[r,c,RotateLeft[data]]
RotateColumns[Matrix[r_,c_,data_]]:=Matrix[r,c,RotateLeft/@data]


RotateRows[Matrix[r_,c_,data_],n_]:=Matrix[r,c,RotateLeft[data,n]]
RotateColumns[Matrix[r_,c_,data_],n_]:=Matrix[r,c,RotateLeft[#,n]&/@data]


UniversalKhTimingData={};


twist[\[Alpha]_,k_,\[Lambda]_,\[Mu]_,\[Nu]_]:=\[Nu]-(1/\[Alpha])T^(-k)\[Mu].\[Lambda]


UniversalKh[K:((Knot|Link|TorusKnot)[_Integer,__])]:=UniversalKh[K]=Module[{result,components,factor},
CreditMessage[UniversalKh::about];
result=AbsoluteTiming[DecomposeComplex[GradingsList[KhN[K]],Matrices[KhN[K]]]];
AppendTo[UniversalKhTimingData,{K,result[[1]]/.Second->1}];
result[[2]]
]
UniversalKh[d_PD]:=DecomposeComplex[GradingsList[KhN[d]],Matrices[KhN[d]]]


DecomposeComplex[{g0_, gradings0_}, {g0_, matrices0_List}] := Module[
{g = g0, gradings = gradings0, matrices = matrices0, result = 0, 
    matrix, objects, exponents, i, j, k, \[Alpha], \[Lambda], \[Mu], \[Nu]}, 
While[
   Length[matrices] > 0,
   objects = gradings[[1]];
   matrix = matrices[[1]];
   While[(exponents = DeleteCases[Union[(Exponent[#1, T] & ) /@ Flatten[MatrixData[matrix]]], -Infinity]) != {}, 
     k = First[exponents];
     If[k == 0, Print["Found an isomorphism I wasn't expecting!"]; Return[$Failed]];
     {i, j} = Position[MatrixData[matrix], e_ /; Exponent[e, T] == k, 2, 1][[1]];
     objects = RotateLeft[objects, j - 1];
     gradings[[2]] = RotateLeft[gradings[[2]], i - 1];
     matrix = RotateRows[matrix, i - 1];
     matrix = RotateColumns[matrix, j - 1];
     If[Length[matrices] > 1, matrices[[2]] = RotateColumns[matrices[[2]], i - 1]];
     \[Alpha] = matrix[[1,1]]/T^k;
     \[Lambda] = RestColumns[FirstRow[matrix]];
     \[Mu] = RestRows[FirstColumn[matrix]];
     \[Nu] = RestRows[RestColumns[matrix]];
     matrix = twist[\[Alpha], k, \[Lambda], \[Mu], \[Nu]];
     If[Length[matrices] > 1, matrices[[2]] = RestColumns[matrices[[2]]]]; 
     result += t^(g + 1)*q^(2*k + objects[[1]])*KhC[k];
     objects = Rest[objects];
     gradings[[2]] = Rest[gradings[[2]]];
   ]; 
   If[ !ZeroMatrixQ[matrix], Return[$Failed]];
   result += KhE*Plus @@ (t^g*q^#1 & ) /@ objects;
   matrices = Rest[matrices];
   gradings = Rest[gradings]; g++;
   ];
 result += KhE*Plus @@ (t^g*q^#1 & ) /@ gradings[[1]];
 result
 ]


sInvariant[K_]:=With[{ukh=UniversalKh[K]},
If[Length[Position[ukh,KhE]]==1,
Replace[ukh/.{_KhC:>0,KhE->1},{q^s_.:>s,1->0}],
ukh/.{_KhC:>0,KhE->1}
]
]


\[Alpha]0rules={KhE->q+q^-1,KhC[1]->t^-1 q^-3+ q^1,KhC[n_]/;n>=2:>(q+q^-1)(t^-1 q^(-2n)+1)};


reducedRules={KhE->q^-1,KhC[n_]:>t^-1 q^(-2n-1)+q^-1};


KhReduced[K_]:=Function[{q,t},Evaluate[Expand[UniversalKh[K]/.reducedRules]]]


End[]


EndPackage[]
