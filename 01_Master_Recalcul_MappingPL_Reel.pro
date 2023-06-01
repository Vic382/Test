601,100
602,"01_Master_Recalcul_MappingPL_Reel"
562,"VIEW"
586,"Cloture"
585,"Cloture"
564,
565,"jC]6L]]gE0a21Ap[tvNL<5gMWga?I6t3eltW6aSbd53FWd3VPgt5`eTkP10gd7PtcIZINVix_9NcWl^tm>1WzmBsw]u=wvKhd2v?9ndzus:JPN=ef0kiJwCpk5KW`Qa=Iqbe>ULfo0OZ@J74bq<^xiYnpGV\s4U6LDZvFDK[;bDOH?1tqAWDit_wnW_qlsWknmr>Ng4M"
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
589," "
568,""""
570,Activation_Periode_Chargement
571,
569,0
592,0
599,1000
560,2
pAnnee
pMois
561,2
2
2
590,2
pAnnee,""
pMois,""
637,2
pAnnee,""
pMois,"MXX ou * pour tous les mois"
577,7
m_Cloture
Annee
Mois
Valeur
NVALUE
SVALUE
VALUE_IS_STRING
578,7
2
2
2
2
1
2
1
579,7
3
1
2
4
0
0
0
580,7
0
0
0
0
0
0
0
581,7
0
0
0
0
0
0
0
582,4
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
603,0
572,156

#****Begin: Generated Statements***
#****End: Generated Statements****


#*****************************************************************************
# CREATEUR : DIMO SOFTWARE: GMU
# DATE DE CREATION : 01/07/2021
# DERNIERE MODIFICATION EFFECTUEE PAR : MDP
# DATE DE DERNIERE MODIFICATION : 03/08/2021.
# Commentaire Modif : Modif pMois remplacé par Mois
# DESCRIPTION DU PROCESSUS : Permet de charger les données dupuis le Grand livre
# et la Balance vers le PL sans chargement de fichier. 
# Le recalcul des clés pour le drills est aussi effectué . 
#*****************************************************************************
#***********************************************************************************************************
#                                  Définition des cubes
#***********************************************************************************************************

#Definition des cubes
sCubeParamS = 'ParametresSources' ;
sCubeParamT = 'ParametrageT' ;
sCubeParamF = 'ParametreF' ; 
sCubeCloture = 'Cloture' ;


#**********************************************************************************************************
#                                  Définition des constantes
#***********************************************************************************************************

cMainProcName = GetProcessName();
cRepertoireRacine = GetProcessErrorFileDirectory;
cTimeStamp = TimSt( Now, '\Y\m\d\h\i\s' );
cRandomInt = NumberToString( INT( RAND( ) * 1000 ));
cTimeProcess = cTimeStamp | '_' | cRandomInt;


#**********************************************************************************************************
#                                  Initialisation des variables
#**********************************************************************************************************
nDebug  = 1 ;
nProcessReturnCode= 0;
zLogNumero	= 1 ;

nMetaCount	= 0 ;
nDataCount	= 0 ;

nCountAttribut	= 0 ;
nCountParent	= 0 ;
nCountElement	= 0 ;
nCountWarn            = 0 ;

nErrors		= 0 ;

pLegacy		= 0 ;
#pDelim	             	= TRIM(pDelim);
pLogOutput             = 1 ;

# Déclaration de variables techniques
sProcessBegin = TimSt (Now(), '\d/\m/\Y - \h:\i:\s') ;
sProcessDateHeure = TimSt (Now(), '\d\m\Y_\hh\im\ss') ;
zCubeTech = 'ParametrageT' ;
sElemSource = 'Txt_RepertoireExe' ;
sElemTech = 'ValeurS' ;
nNbErrors = 0;

#**********************************************************************************************************
#                                  Test du mois
#***********************************************************************************************************

# Mois erroné
IF ( DIMIX ( 'Mois', pMois) = 0 & TRIM(pMois) @<>'*'  ) ;
    	ExecuteProcess( 'Process.Log.Create', 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , 'FATAL' ,
		'pV1' , IF ( pMois@='', 'Paramétre mois vide', 'Paramétre mois érroné : ' | pMois) ) ;
               nErrors = 1 ;
               ProcessBreak ;
ENDIF ;

#**********************************************************************************************************
#                                  Test Annee
#***********************************************************************************************************

# Annee erronée
IF ( DIMIX ( 'Annee', pAnnee )  = 0 & TRIM( pAnnee ) @<>'*'  ) ;
    	ExecuteProcess( 'Process.Log.Create', 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , 'FATAL' ,
		'pV1' , IF ( pAnnee @='', 'Paramétre année vide', 'Paramétre année érroné : ' | pAnnee) ) ;
               nErrors = 1 ;
               ProcessBreak ;
ENDIF ;

###########################################
## Creation vue Source
###########################################

###****Déclaration des variables

sCubeSource = 'Cloture' ;

sDim1 = 'Annee' ;
sDim2 = 'Mois' ;
sDim = 'm_Cloture' ;

sVueSource = 'zTI_' | cMainProcName | '_Source';

IF( ViewExists( sCubeSource, sVueSource ) = 1 );
  ViewDestroy( sCubeSource , sVueSource );
ENDIF;
ViewCreate( sCubeSource , sVueSource, nDebug );

#ANNEE
IF( SubsetExists( sDim1 , sVueSource ) = 1 );
  SubsetDestroy( sDim1 , sVueSource );
ENDIF;
SubsetCreate ( sDim1 , sVueSource ) ;
SubsetElementInsert ( sDim1 , sVueSource , pAnnee  , 1 ) ;
ViewSubsetAssign( sCubeSource , sVueSource , sDim1 , sVueSource );

#MOIS
IF( SubsetExists( sDim2 , sVueSource ) = 1 );
  SubsetDestroy( sDim2 , sVueSource );
ENDIF;

IF ( TRIM(pMois) @= '*' ) ;
   SubsetCreatebyMDX( sVueSource , '{TM1FILTERBYLEVEL( {TM1SUBSETALL(['|sDim2|'] )}, 0)}');
ELSE;
   SubsetCreate ( sDim2 , sVueSource ) ;
   SubsetElementInsert ( sDim2 , sVueSource , pMois  , 1 ) ;
ENDIF;
ViewSubsetAssign( sCubeSource, sVueSource , sDim2 , sVueSource );

#M_Cloture
IF( SubsetExists( sDim , sVueSource ) = 1 );
  SubsetDestroy( sDim , sVueSource );
ENDIF;
SubsetCreatebyMDX( sVueSource , '{TM1FILTERBYLEVEL( {TM1SUBSETALL(['|sDim|'] )}, 0)}');
ViewSubsetAssign( sCubeSource, sVueSource , sDim , sVueSource );

#### Uniquement pour une vue source ####
ViewExtractSkipCalcsSet( sCubeSource , sVueSource , 1 );
ViewExtractSkipZeroesSet( sCubeSource , sVueSource , 1 );
ViewExtractSkipRuleValuesSet( sCubeSource , sVueSource , 1 );

#Définition de la source
DataSourceNameForServer = sCubeSource ;
DatasourceCubeView = sVueSource ;











573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,52

#****Begin: Generated Statements***
#****End: Generated Statements****

#**********************************************************************************************************
#                                  Lancement de l'éxécution des processsus
#                                   de chargement des données sources
#                                   de chargement de cube à cube
#**********************************************************************************************************

# On vérifie si la valeur est active c'est à dire que le mois n'est pas cloturé. 
IF ( Valeur @='Actif' ) ; 

    # On récupère la valeur présente dans les variables 
    pAnnee = DimensionElementPrincipalName( 'Annee' , pAnnee );
#    pMois = DimensionElementPrincipalName( 'Mois', pMois ) ; 
	# TMR MàJ 30.08.2021 : Ticket https://www.supportdimo.com/pages/ticket/ticket.php?id=426519
	# On supprime les paramètres pPhase et 'pVersion'
	# Par défaut, la phase est égale à Réel et la version V1.
	sPhase = 'R' ; 
	sVersion = 'V1' ; 
    #**********************************************************************************************************
    #                                  Chargement des données dans le Grand livre
    #                                  Conversion des devise si besoin
    #                                  puis dans le PL
    #**********************************************************************************************************

        # Chargement des données du cube GL vers le cube PL en Year To Date puis en Month To Date
        ExecuteProcess ( 'Maj_Data_PL_Grand_Livre_YTD' , 'pAnnee' , pAnnee , 'pVersion' , sVersion  , 'pPhase' , sPhase  , 'pMois' , Mois );
        ExecuteProcess ( 'Maj_Data_PL_MTD' , 'pAnnee' , pAnnee , 'pVersion' , sVersion  , 'pPhase' , sPhase  , 'pMois' , Mois );
        # Chargement des données du cube Balance vers le cube PL
        ExecuteProcess ( 'Maj_Data_PL_Balance' , 'pAnnee' , pAnnee , 'pVersion' , sVersion  , 'pPhase' , sPhase  , 'pMois' , Mois );

        # Chargement des données du cube GL vers le cube PL en Year To Date puis en Month To Date
       ExecuteProcess ( 'Maj_Data_PL_Saisie_Grand_Livre_YTD' , 'pAnnee' , pAnnee , 'pVersion' , sVersion  , 'pPhase' , sPhase  , 'pMois' , Mois ) ;
       ExecuteProcess ( 'Maj_Data_PL_Saisie_MTD' , 'pAnnee' , pAnnee , 'pVersion' , sVersion  , 'pPhase' , sPhase  , 'pMois' , Mois ) ;  
	
       # Chargement des données du cube Balance vers le cube PL
       ExecuteProcess ( 'Maj_Data_PL_Saisie_Balance' , 'pAnnee' , pAnnee , 'pVersion' , sVersion  , 'pPhase' , sPhase  , 'pMois' , Mois );

EndIf ; 











575,4

#****Begin: Generated Statements***
#****End: Generated Statements****

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
