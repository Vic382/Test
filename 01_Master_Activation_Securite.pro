601,100
602,"01_Master_Activation_Securite"
562,"SUBSET"
586,"}Clients"
585,"}Clients"
564,
565,"tHkt7S8R_SHYXh2rdLV7alxhy2edmnK]QSDnAvgMQpLFbxa;64SKi4p2Pdupzcrg@<bcS2pMSHeSqVGQ[wY]igcGqArqjI9DBFTtFBHXsvwFlRpNSSkFt\Tu3zVrtXM30<1lXp;<L7R9?JWE8Fjv<AAV>5@9^s<@pf@3VC_IeWVr_qE4lBoX[F\KaS8ngd>2_L1J8LOq"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,","
589,
568,""""
570,
571,All
569,0
592,0
599,1000
560,1
pAction
561,1
2
590,1
pAction,"blocage"
637,1
pAction,"blocage ou déblocage"
577,1
sUtilisateur
578,1
2
579,1
1
580,1
0
581,1
0
582,1
VarType=32ColType=827
603,0
572,109

#****Begin: Generated Statements***
#****End: Generated Statements****


#### Initialisation des variables
sADM_TECH = 'ADM_TECH' ;
sADM_FONC = 'ADM_FONC' ;
sCubeClientProperties = '}ClientProperties' ;
sCubeClientGroups = '}ClientGroups' ;
sCubeUtilisateurs = 'z_Utilisateur' ;
sGroupeAdmin = 'ADMIN' ;
sGroupeSecurityAdmin = 'SecurityAdmin' ;
sGroupeDataAdmin = 'DataAdmin' ;
sADM_TECH_Param = 'ADM_TECH' ;
sADM_FONC_Param = 'ADM_FONC' ;
#sPasswordExpirationDaysParam = 'PasswordExpirationDays' ;
sPasswordExpirationDaysParam = 'IsDisabled' ;
sBlocage = 0 ;

################
#### ETAPE 1
################

#### Validation des paramètres
sAction_Validation = LOWER( TRIM( pAction ) ) ;
IF( sAction_Validation @<> 'blocage'
  & sAction_Validation @<> 'deblocage'
  & sAction_Validation @<> 'déblocage' ) ;
  ProcessError ;
ENDIF ;

#### Ajustement pour enlever l'accent
IF( sAction_Validation @= 'blocage' ) ;
  sBlocage = 1 ;
ENDIF ;

################
#### ETAPE 2
################

#### Création de la vue à purger
sCubeRAZ = sCubeClientProperties ;
sVueRAZ = 'z_TI_' | GetProcessName | '_RAZ' ;

IF( ViewExists( sCubeRAZ , sVueRAZ ) <> 0 ) ;
  ViewDestroy( sCubeRAZ , sVueRAZ ) ;
ENDIF ;
ViewCreate( sCubeRAZ , sVueRAZ ) ;

## }Client
sDimension = '}Clients' ;

IF( SubsetExists( sDimension , sVueRAZ ) <> 0 ) ;
  SubsetDestroy( sDimension , sVueRAZ ) ;
ENDIF ;
SubsetCreate( sDimension , sVueRAZ ) ;
SubsetIsAllSet( sDimension , sVueRAZ , 1 ) ;
ViewSubsetAssign( sCubeRAZ , sVueRAZ , sDimension , sVueRAZ ) ;


## }ClientProperties
sDimension = '}ClientProperties' ;
IF( SubsetExists( sDimension , sVueRAZ ) <> 0 ) ;
  SubsetDestroy( sDimension , sVueRAZ ) ;
ENDIF ;
SubsetCreate( sDimension , sVueRAZ ) ;
SubsetElementInsert( sDimension , sVueRAZ , sPasswordExpirationDaysParam , 1 ) ;
ViewSubsetAssign( sCubeRAZ , sVueRAZ , sDimension , sVueRAZ ) ;

#### Purge de la vue
ViewZeroOut( sCubeRAZ , sVueRAZ ) ;

#### Destruction des éléments techniques créés
IF( ViewExists( sCubeRAZ , sVueRAZ ) <> 0 ) ;
  ViewDestroy( sCubeRAZ , sVueRAZ ) ;
ENDIF ;

## }Client
sDimension = '}Clients' ;
IF( SubsetExists( sDimension , sVueRAZ ) <> 0 ) ;
  SubsetDestroy( sDimension , sVueRAZ ) ;
ENDIF ;

## }ClientProperties
sDimension = '}ClientProperties' ;
IF( SubsetExists( sDimension , sVueRAZ ) <> 0 ) ;
  SubsetDestroy( sDimension , sVueRAZ ) ;
ENDIF ;

#### Finalisation du processus dans le cas d'un déblocage
IF( sBlocage = 0 ) ;
  ProcessBreak ;
ENDIF ;

################
#### ETAPE 3
################

#### Création du subset Source
sDimension = '}Clients' ;
sSubsetSource = 'z_TI_' | GetProcessName | '_Source' ;
IF( SubsetExists( sDimension , sSubsetSource ) <> 0 ) ;
  SubsetDestroy( sDimension , sSubsetSource ) ;
ENDIF ;
SubsetCreate( sDimension , sSubsetSource ) ;
SubsetIsAllSet( sDimension , sSubsetSource , 1 ) ;

DatasourceDimensionSubset = sSubsetSource ;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,30

#****Begin: Generated Statements***
#****End: Generated Statements****

#### Initialisation
sFlagAdmin = '' ;
sFlagDataAdmin = '' ;
sFlagSecurityAdmin = '' ;
sFlagAdmin_TECH = 0 ;
sFlagAdmin_FONC = 0 ;

#### Vérification initiale pour réperer les admins non répertoriés dans le groupe z_Utilisateur
sFlagAdmin = CellGetS( sCubeClientGroups , sUtilisateur , sGroupeAdmin ) ;
sFlagDataAdmin = CellGetS( sCubeClientGroups , sUtilisateur , sGroupeDataAdmin ) ;
sFlagSecurityAdmin = CellGetS( sCubeClientGroups , sUtilisateur , sGroupeSecurityAdmin ) ;

## Si l'utilisateur est ADMIN, alors on passe à l'utilisateur suivant
IF( sFlagAdmin @<> '' 
  % sFlagDataAdmin @<> '' 
  % sFlagSecurityAdmin @<> '' ) ;
#  ItemReject( sUtilisateur ) ;
  ItemSkip ;
ENDIF ;

#### Traitement pour les utilisateurs afin de les activer / desactiver
IF( sBlocage = 1 ) ;
  #ItemReject( sUtilisateur | ' Utilisateur normal' ) ;
  #CellPutS( '-1' , sCubeClientProperties , sUtilisateur , sPasswordExpirationDaysParam ) ;
  CellPutN( 1 , sCubeClientProperties , sUtilisateur , 'IsDisabled' ) ;
ENDIF ;
575,11

#****Begin: Generated Statements***
#****End: Generated Statements****

#### Suppression du subset Source
sDimension = '}Clients' ;
IF( SubsetExists( sDimension , sSubsetSource ) <> 0 ) ;
  SubsetDestroy( sDimension , sSubsetSource ) ;
ENDIF ;

SecurityRefresh;
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
