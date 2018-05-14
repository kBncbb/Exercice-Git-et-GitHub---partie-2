#*************************************************************************************************************************
#
#Copyright or Â© or Copr.[DGFIP][2017]
#
#Ce logiciel a Ã©tÃ© initialement dÃ©veloppÃ© par la Direction GÃ©nÃ©rale des 
#Finances Publiques pour permettre le calcul de l'impÃ´t sur le revenu 2016 
#au titre des revenus perÃ§us en 2015. La prÃ©sente version a permis la 
#gÃ©nÃ©ration du moteur de calcul des chaÃ®nes de taxation des rÃ´les d'impÃ´t 
#sur le revenu de ce millÃ©sime.
#
#Ce logiciel est rÃ©gi par la licence CeCILL 2.1 soumise au droit franÃ§ais 
#et respectant les principes de diffusion des logiciels libres. Vous pouvez 
#utiliser, modifier et/ou redistribuer ce programme sous les conditions de 
#la licence CeCILL 2.1 telle que diffusÃ©e par le CEA, le CNRS et l'INRIA  sur 
#le site "http://www.cecill.info".
#
#Le fait que vous puissiez accÃ©der Ã  cet en-tÃªte signifie que vous avez pris 
#connaissance de la licence CeCILL 2.1 et que vous en avez acceptÃ© les termes.
#
#**************************************************************************************************************************
regle 80000:
application : iliad , batch  ;
HRBTRFR1 = V_BTRFRHR1 * (1-positif_ou_nul(RFRH1)) + RFRH1;
HRBTRFR2 = V_BTRFRHR2 * (1-positif_ou_nul(RFRH2)) + RFRH2;
HRNBTRFR = positif_ou_nul(V_BTRFRHR1 * (1-positif(RFRH1)) + RFRH1) + positif_ou_nul(V_BTRFRHR2 * (1-positif(RFRH2)) + RFRH2);
HRMOYBTRFR = arr((HRBTRFR1 + HRBTRFR2) /2);
HRLIM15 = positif_ou_nul(REVKIREHR - (1.5 * HRMOYBTRFR));
HRLIMBTRFR2 = positif_ou_nul(LIMHR1 * (1+BOOL_0AM) - HRBTRFR2);
HRLIMBTRFR1 = positif_ou_nul(LIMHR1 * (1+BOOL_0AM) - HRBTRFR1);
HRCONDTHEO = positif(null(2-HRNBTRFR)*positif(HRLIM15)*positif(HRLIMBTRFR1*HRLIMBTRFR2)* (1-positif(CASECHR+0)));
HRBASEFRAC = arr((REVKIREHR - HRMOYBTRFR) / 2);
HRBASELISSE = HRBASEFRAC + HRMOYBTRFR;
CHRREEL1 = positif_ou_nul(LIMHRTX1 * (1+BOOL_0AM)-REVKIREHR) * ((REVKIREHR - LIMHR1 * (1+BOOL_0AM))*TXHR1/100)
                       + (LIMHR1 * (1+BOOL_0AM) * TXHR1/100) * positif(REVKIREHR - LIMHRTX1 * (1+BOOL_0AM));
CHRREEL2 = max(0,(REVKIREHR - LIMHR2*(1+BOOL_0AM))*TXHR2/100);
CHRREELTOT = arr(max(0,CHRREEL1 + CHRREEL2));
CHRTHEO11 = arr(positif_ou_nul(LIMHRTX1 * (1+BOOL_0AM)-HRBASELISSE) * ((HRBASELISSE - LIMHR1 * (1+BOOL_0AM))*TXHR1/100)
                        + (LIMHR1 * (1+BOOL_0AM) * TXHR1/100)* positif(HRBASELISSE - LIMHRTX1 * (1+BOOL_0AM)));
CHRTHEO21 = arr(max(0,(HRBASELISSE - LIMHR2*(1+BOOL_0AM))*TXHR2/100));
CHRTHEOTOT = arr(max(0,CHRTHEO11 + CHRTHEO21)*2);
BHAUTREV = max(0 , REVKIREHR - LIMHR1 * (1 + BOOL_0AM)) ;
CHRAVANT = (max(0,min(CHRREELTOT,CHRTHEOTOT)) * HRCONDTHEO
                     + CHRREELTOT * (1-HRCONDTHEO) ) ;
CHRTEFF = arr(CHRAVANT * (REVKIREHR - TEFFHRC+COD8YJ)/ REVKIREHR);
CHRAPRES = (CHRAVANT * (1-positif(positif(IPMOND)+positif(INDTEFF))) + CHRTEFF * positif(positif(IPMOND)+positif(INDTEFF))) * (1 - positif(RE168 + TAX1649));
regle 80005:
application : iliad , batch  ;
IHAUTREVT = max(0,CHRAPRES - CICHR);
