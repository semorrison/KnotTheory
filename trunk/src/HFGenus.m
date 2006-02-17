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

ThreeGenus;

Begin["`ThreeGenus`"];

BWReg[K_PD]:=Module[
      {matches,edges, vertices,b,nc,i,p,q,r,s,jleft, jright,idT,regs},
      nc = Length[K];
      matches=Table[{0,0},{4*nc}];
      edges=Table[{b[2*i-1],b[2*i]},{i,2*nc}];
      vertices=Table[{0,0,0,0},{nc}];
      idT=Table[b[i],{i,4*nc}];
      For[i=1,i<nc+1, i++,
        p = K[[i,1]]; q=K[[i,3]];
        vertices[[i]]={b[2*p],b[2*q],b[2*q-1],b[2*p-1]};
        ];
      
      For[p=1,p<nc+1,p++,
        i=K[[p,1]]; j= K[[p,2]];
        k=K[[p,3]]; l=K[[p,4]];
        jleft=-1; jright=0;
        If[Or[(l>j)&&(l=!=2*nc),(l>j)&&(j=!=1),(l\[Equal]1)&&(j=!=2)], 
          jleft=0;
          jright=-1];
        matches[[4p-3]]={b[2*i],b[2*j+jright]};
        matches[[4p-2]]={b[2*j+jleft],b[2*k]};
        matches[[4p-1]]={b[2k-1],b[2l+jleft]};
        matches[[4p]]={b[2l+jright],b[2i-1]};
        ];
      
      For[i=1,i<4nc+1,i++,
        edges=edges /. matches[[i,2]]\[Rule]matches[[i,1]];
        vertices=vertices /. matches[[i,2]]\[Rule]matches[[i,1]];
        idT=idT /. matches[[i,2]]\[Rule]matches[[i,1]];
        matches=matches /. matches[[i,2]]\[Rule]matches[[i,1]];
        ];
      
      regs=Union[idT];
      For[i=1,i<Length[regs]+1,i++,
        edges=edges /. regs[[i]]\[Rule]i;
        vertices=vertices /. regs[[i]]\[Rule]i;
        matches=matches /. regs[[i]]\[Rule]i;
        ];
      {Length[regs],edges,vertices}];

KStates[K_PD,rut_]:=Module[
      {cr,StateList,edges,vertices,du,rdat,vdat,edat,nreg},
      
      Placer[pos_,used_]:=Module[
          {i,vtx,nused},
          vtx=Length[pos]+1;
          If[vtx\[Equal]cr+1,
            StateList=Append[StateList,pos],
            For[i=1,i<5,i++,
                tr = vdat[[vtx,i]];
                If[used[[tr]]\[Equal]0,
                  nused=used; 
                  nused[[tr]]=1;
                  Placer[Append[pos,i],nused]]
                ];
            ];
          0];
      
      StateList={};
      cr=Length[K];
      rdat=BWReg[K]; nreg=rdat[[1]];
      edat=rdat[[2]]; vdat=rdat[[3]];
      du=Table[0,{nreg}];
      du[[edat[[rut,1]]]]=1;
      du[[edat[[rut,2]]]]=1;
      Placer[{},du];
      StateList];

crs[s_X]:=Module[
      {t},
      t=1; 
      If[Or[s[[2]]\[Equal](s[[4]]-1),(s[[4]]\[Equal]1)&&(s[[2]]=!=2)],t=-1];
      t];

AlexGr[state_,K_PD]:=Module[
      {i,g},
      Al[1,1]:=0; Al[1,2]:=-1/2;
      Al[1,3]:=0; Al[1,4]:=1/2;
      Al[-1,1]:=-1/2; Al[-1,2]:=0;
      Al[-1,3]:=1/2; Al[-1,4]:=0;
      g=0;
      For[i=1,i<Length[state]+1,i++,
        g=g+Al[crs[K[[i]]],state[[i]]]
        ];
      g];

HomGr[state_,K_PD]:=Module[
      {i,g},
      HG[1,1]:=0; HG[1,2]:=-1;
      HG[1,3]:=0; HG[1,4]:=0;
      HG[-1,1]:=0; HG[-1,2]:=0;
      HG[-1,3]:=1; HG[-1,4]:=0;
      g=0;
      For[i=1,i<Length[state]+1,i++,
        g=g+HG[crs[K[[i]]],state[[i]]]
        ];
      g];

AlexP[K_PD,rut_]:=Module[
      {p,i,states,ags,hgs},
      states=KStates[K,rut];
      ags=Table[AlexGr[states[[i]],K],{i,Length[states]}];
      hgs=Table[HomGr[states[[i]],K],{i,Length[states]}];
      p=0;
      For[i=1,i<Length[states]+1, i++,
        p=p+(-1)^hgs[[i]]*t^ags[[i]]];
      p];

Domain[K_PD,state_,rut_]:=Module[
      {nc,edge,domc,lc,flag,vtx,cor,i,j,A,B},
      A={{-1,-1,1,1},{0,0,0,0},{1,1,-1,-1},{0,0,0,0}};
      B={{0,0,0,0},{-1,1,1,-1},{0,0,0,0},{1,-1,-1,1}};
      nc=Length[K];
      succ[i_]:=Mod[i+1,2*nc,1];
      domc=Table[{0,0},{2*nc}];
      lc={0,0};
      edge=rut; flag=0;
      While[(edge=!=rut)||(flag\[Equal]0),
        vtx=0;
        For[i=1,i<nc+1,i++,
          For[j=1,j<5, j++,
              If[(K[[i,j]]\[Equal]edge)&&(K[[i,Mod[j+2,4,1]]]\[Equal]
                        succ[edge]),
                  vtx=i; cor=j;
                  ];
              ];
          ];
        If[vtx\[Equal]0,Print["vertex not found!"]];
        lc=lc+{A[[cor,state[[vtx]]]],B[[cor,state[[vtx]]]]};
        edge=succ[edge];
        domc[[edge]]=lc;
        flag=1;
        ];
      If[(lc[[1]]+lc[[2]])=!=4*AlexGr[state,K], Print["Error in Domain"]];
      domc];

RelDom[K_PD,rut_,statea_,stateb_]:=Domain[K,statea,rut]-Domain[K,stateb,rut];



SortedStates[K_PD,rut_]:=Module[
      {Y,BT},
      Y=KStates[K,rut];
      BT=Table[{AlexGr[Y[[i]],K], HomGr[Y[[i]],K],Y[[i]]},{i,Length[Y]}];
      Sort[BT]];

SCompare[K_PD,rut_,statea_,stateb_]:=Module[{D,i,ret},
      D=Flatten[RelDom[K,rut,statea,stateb]];
      ret=1;
      For[i=1,i<Length[D]+1,i++,
        If[D[[i]]<0,ret=0]];
      ret];

NoDisk[dom_]:=Module[
      {flag,i,x},
      flag=0;
      x=Flatten[dom];
      For[i=1,i<Length[x]+1,i++,
        If[x[[i]]<0,flag=1]
        ];
      flag];

SmallDisk[dom_]:=Module[
      {flag,i,x}, 
      flag=2;
      For[i=1,i<Length[dom]+1,i++,
        x=dom[[i]];
        If[(x\[Equal]{0,2})||(x\[Equal]{2,0}),flag=flag-1,
          If[(x=!={0,0}), flag=0]
          ];
        ];
      If[flag=!=1,flag=0];
      flag];

BigDisk[dom_]:=Module[
      {flag,i,x},
      flag=3;
      For[i=1,i<Length[dom]+1,i++,
        x=dom[[i]]; 
        If[x\[Equal]{0,2},If[flag>1, flag=2,flag=0],
          
          If[x\[Equal]{2,0},
              If[(flag\[Equal]3)||(flag\[Equal]1), flag=1, flag=0],
              If[x=!={0,0}, flag=0]
              ];
          ];
        ];
      flag];

Comparer[K_PD,rut_,ag_,dflag_]:=Module[
      {Y,i,j,maxg,ming,Z,t,loc,dto,sdto,bdto,rd},
      
      Y=SortedStates[K,rut];
      Z=Select[Y,#[[1]]\[Equal]ag&];
      
      CTest[x_,y_]:=SCompare[K,rut,Z[[x,3]],Z[[y,3]]];
      CDom[x_,y_]:=RelDom[K,rut,Z[[x,3]],Z[[y,3]]];
      
      maxg=Z[[1,2]]; ming=Z[[1,2]];
      For[i=1,i<Length[Z]+1,i++,
        t=Z[[i,2]];
        If[t>maxg, maxg=t];
        If[t<ming,ming=t]];
      
      loc=Length[Z];
      For[i=maxg,i>ming,i--,
        Print["Homological Grading ",i];
        While[Z[[loc,2]]\[Equal]i,
          dto={}; sdto={}; bdto={};
          For[j=1,j<Length[Z]+1,j++,
            If[(Z[[j,2]]\[Equal]i-1)&&(CTest[loc,j]\[Equal]1),
                dto=Append[dto,j];
                rd = CDom[loc,j];
                If[SmallDisk[rd]\[Equal]1,sdto=Append[sdto,j]];
                If[BigDisk[rd]>0,bdto=Append[bdto,j]];
                If[dflag[[4]]\[Equal]1, Print[loc,"   ",j];
                  Print[Diff[K,rut,ag,loc,j]]];
                ];
            ];
          If[dflag[[3]]\[Equal]1,Print[loc,"  ",dto]];
          If[dflag[[1]]\[Equal]1,Print[loc,"  ",sdto]];
          If[dflag[[2]]\[Equal]1,Print[loc,"  ",bdto]];
          loc--];
        ];
      
      Z];

Diff[K_PD,rut_,ag_,n_,m_]:=Module[
      {Z},
      
      Y=SortedStates[K,rut];
      Z=Select[Y,#[[1]]\[Equal]ag&];
      RelDom[K,rut,Z[[n,3]],Z[[m,3]]]];

NStat[K_PD,ag_]:=Module[
      {i,Y,X,A},
      A=AlexP[K,1];
      Print[A];
      For[i=1, i<2*Length[K]+1,i++,
        If[AlexP[K,i]=!=A,Print["Error in NStat"]];
        Y=SortedStates[K,i];
        Z=Select[Y,#[[1]]\[Equal]ag&];
        Print[i,"   ",Length[Z]];
        ];
      0];

StatD[K_PD,agmin_,agmax_]:=Module[
      {i,j,Y,X,A},
      A=AlexP[K,1];
      Print[A];
      For[i=1, i<2*Length[K]+1,i++,
        If[AlexP[K,i]=!=A,Print["Error in NStat"]];
        Y=SortedStates[K,i];
        Print["Root =",i];
        For[j=agmin, j<agmax+1, j++,
          Z=Select[Y,#[[1]]\[Equal]j&];
          Print[j,"   ",Length[Z]];
          ];
        ];
      0];

PSupport[a_]:=Module[
      {i,b,l},
      f[j_]:=(a[[j,1]]=!=0);
      l=Length[a];
      b=Table[i,{i,1,l}];
      Select[b,f]];

NSupport[a_]:=Module[
      {i,b,l},
      f[j_]:=(a[[j,2]]=!=0);
      l=Length[a];
      b=Table[i,{i,1,l}];
      Select[b,f]];

Separated[K_PD,rut_,ag_,hg_,pdisks_,ndisks_]:=
    Module[{Y,Z,i,j,D,big,closegens},
      Y=SortedStates[K,rut];
      Z=Select[Y,((#[[1]]\[Equal]ag)&&(#[[2]]\[Equal]hg))&];
      For[i=1,i<Length[Z]+1,i++,
        closegens={};
        For[j=i+1, j<Length[Z]+1,j++,
          D=RelDom[K,rut,Z[[i,3]],Z[[j,3]]];
          
          big=Union[Complement[PSupport[D],pdisks], 
              Complement[NSupport[D],ndisks]];
          If[big\[Equal]{},closegens = Append[closegens,j]]
          ];
        Print[i,"  ",closegens];
        ];
      Z];


SAGenus[K_PD]:=Module[
      {Y,S,i,tcr,srule},
      Y=List@@K;
      S=Thread[crs[Y]];
      For[i=1,i<Length[Y]+1,i++,
        tcr=Y[[i]];
        srule={tcr[[4]]\[Rule]tcr[[1]],tcr[[3]]\[Rule]tcr[[2]]};
        If[S[[i]]==1, 
          srule={tcr[[2]]\[Rule]tcr[[1]],tcr[[4]]\[Rule]tcr[[3]]}];
        Y=Y/.srule
        ];
      Y=Union[Flatten[Apply[List,Y,{1}]]];
      (1+Length[K]-Length[Y])/2];


Clik[X_,ClSize_]:=Module[
      {i,j,d,ret,found,nos,ToDiff,FromDiff},
      d=Length[X];
      nos=Table[i,{i,d}];
      ToDiff=Table[Select[nos,X[[i,#]]\[Equal]0&],{i,d}];
      FromDiff=Table[Select[nos,X[[#,i]]\[Equal]0&],{i,d}];
      found=0; i=0;
      While[(i<ClSize+1)&&(found\[Equal]0),
        S=Subsets[nos,{i}];j=1;
        While[(j<Length[S]+1)&&(found\[Equal]0),
          dto=0; dfrom=0;
          For[k=1,k<d+1,k++,
            If[Length[Union[ToDiff[[k]],S[[j]]]]\[Equal]i,dto++];
            If[Length[Union[FromDiff[[k]],S[[j]]]]\[Equal]i,dfrom++]];
          
          If[(dfrom>i)||(dto>i),
            found=1; (*Print[S[j],"   ",ToDiff,FromDiff]*)];
          j++];
        i++];
      found];

Canc[X_]:=Module[
      {ret,td},
      ret=0;
      td=Total[Flatten[X]];
      ds = X[[1,1]]+X[[2,2]];
      If[(Length[X]\[Equal]2)&&((td\[Equal]3)||((td\[Equal]2)&&EvenQ[ds])),
        ret=1; (*Print["Found a Canc"]*)];
      ret];

TestGenus[K_PD,rut_,ag_]:=Module[
      {Y,Z,CDom,g,ngen,NoDiffs,SmallDiffs,i,j},
      
      Y=SortedStates[K,rut];
      Z=Select[Y,#[[1]]\[Equal]ag&];
      
      CDom[x_,y_]:=RelDom[K,rut,Z[[x,3]],Z[[y,3]]];
      (*Print[Z];*)
      g=-1;
      If[Z[[1,2]]\[Equal](Z[[Length[Z],2]]-1), 
        ngen=Length[Z]/2;
        If[Not[IntegerQ[ngen]],Print["Error in TestGenus"]];
        NoDiffs=Table[NoDisk[CDom[i+ngen,j]],{i,1,ngen},{j,1,ngen}];
        (*Print["NoDiffs= ", NoDiffs];*)
        If[Clik[NoDiffs,0]\[Equal]1,g=Abs[ag]];
        SmallDiffs=Table[SmallDisk[CDom[i+ngen,j]],{i,1,ngen},{j,1,ngen}];
        (*Print["SmallDiffs= ", SmallDiffs];*)
        If[Canc[SmallDiffs]\[Equal]1, g=Abs[ag]-1];
        ];
      g];

FindClik[K_PD,rut_,ag_,ClDepth_]:=Module[
      {Y,Z,CDom,g,ngen,NoDiffs,SmallDiffs,i,j},
      
      Y=SortedStates[K,rut];
      Z=Select[Y,#[[1]]\[Equal]ag&];
      ngen=Length[Z]/2;
      CDom[x_,y_]:=RelDom[K,rut,Z[[x,3]],Z[[y,3]]];
      
      NoDiffs=Table[NoDisk[CDom[i+ngen,j]],{i,1,ngen},{j,1,ngen}];
      
      Clik[NoDiffs,ClDepth]];


UpperGCheck[K_PD,g_,ClDepth_]:=Module[
      {i,NPG,NMG,NGen, found},
      
      NPG=
        Table[{Length[Select[SortedStates[K,i],#[[1]]\[Equal]g&]],i,g},{i,
            2*Length[K]}];
      NMG=
        Table[{Length[Select[SortedStates[K,i],#[[1]]\[Equal]-g&]],i,-g},{i,
            2*Length[K]}];
      NGen=Sort[Join[NPG,NMG]];
      
      found=0; i=1;
      While[(found\[Equal]0)&&(i<Length[NGen]+1),
        found=FindClik[K,NGen[[i,2]],NGen[[i,3]],ClDepth];
        If[found\[Equal]1,Print["Clik found ",NGen[[i]]]];
        i++];
      found];

ThreeGenus[K_] := ThreeGenus[PD[K]];
ThreeGenus[K_PD]:=ThreeGenus[K] = Module[
        {AGen,SAGen,ret,i,stat,flag,BigA,p,groot,las,qflag,dom,g, MaxG},
        CreditMessage[
          "The three genus program was written by Jake Rasmussen of Princeton University."]\
;
        Needs["DiscreteMath`Combinatorica`"];
        ret={-1,-1};
        AGen=Exponent[Alexander[K][t],t];
        SAGen=SAGenus[K];
        If[AGen\[Equal]SAGen, ret={AGen,0}, 
          i=1; flag=0; BigA={SAGen,1000}; groot={};
          While[(i<2*Length[K]+1)&&(flag\[Equal]0),
            stat=SortedStates[K,i];
            p={stat[[1,1]],Length[Select[stat,#[[1]]\[Equal]stat[[1,1]]&]]};
            qflag=0;
            (*Print[BigA];*)
            
            If[(Abs[p[[1]]]<
                    Abs[BigA[[1]]])||((Abs[p[[1]]]\[Equal]
                        Abs[BigA[[1]]])&&(p[[2]]<BigA[[2]])),
              (*Print[BigA,"   ",p];*)
               BigA=p; qflag=1;groot={Flatten[{i,p}]}, 
              
              If[(Abs[p[[1]]]\[Equal]Abs[BigA[[1]]])&&(p[[2]]==BigA[[2]]), 
                qflag=1;
                groot=Append[groot,Flatten[{i,p}]]]];
            
            If[(qflag\[Equal]1 )&& (p[[2]]\[Equal]2)&&(Abs[p[[1]]]>AGen),
              dom=RelDom[K,i,stat[[2,3]],stat[[1,3]]];
              (*Print[stat[[2]],stat[[1]],dom];*)
              If[NoDisk[dom]\[Equal]1,flag=1;ret={Abs[p[[1]]],3}];
              If[SmallDisk[dom]\[Equal]1, BigA={Abs[p[[1]]]-1,100};
                (*Print[BigA];*) groot={}];
              ];
            
            las=Length[stat];
            
            p={stat[[las,1]],
                Length[Select[stat,#[[1]]\[Equal]stat[[las,1]]&]]};
            qflag=0;
            
            If[(Abs[p[[1]]]<
                    Abs[BigA[[1]]])||((Abs[p[[1]]]\[Equal]Abs[BigA[[1]]])&&(p[
                          [2]]<BigA[[2]])), 
              (*Print[BigA,"   ",p];*)
              BigA=p; qflag=1;groot={Flatten[{i,p}]}, 
              
              If[(Abs[p[[1]]]\[Equal]Abs[BigA[[1]]])&&(p[[2]]==BigA[[2]]), 
                qflag=1;
                groot=Append[groot,Flatten[{i,p}]]]];
            
            If[(qflag\[Equal]1 )&& (p[[2]]\[Equal]2)&&(Abs[p[[1]]]>AGen),
              dom=RelDom[K,i,stat[[las,3]],stat[[las-1,3]]];
              (*Print[stat[[las]],stat[[las-1]],dom];*)
              If[NoDisk[dom]\[Equal]1,flag=1;ret={Abs[p[[1]]],3}];
              
              If[SmallDisk[dom]\[Equal]1, BigA={Abs[p[[1]]]-1,1000}; 
                groot={}];
              ];
            
            If[Abs[BigA[[1]]]\[Equal]AGen,flag=1; ret={AGen,1}];
            i++];
          
          MaxG=Abs[BigA[[1]]];
          If[flag\[Equal]0, 
            i=1;
            While[(flag\[Equal]0)&&(i<Length[groot]+1),
              g=TestGenus[K,groot[[i,1]],groot[[i,2]]];
              (*Print["Trying  ",groot[[i,1]],"   ",groot[[i,2]]];*)
              If[g\[Equal]MaxG,ret={g,3}; flag=1];
              If[g\[Equal]AGen, ret={g,4};flag=1];
              i++];
            ];
          
          If[flag\[Equal]0,ret={{MaxG,AGen},2}];
          ];
        First[ret] /. {max_Integer, min_Integer} \[RuleDelayed] {min, max}
        ];

End[]; EndPackage[];