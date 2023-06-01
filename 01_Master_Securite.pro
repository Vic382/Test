601,100
602,"01_Master_Securite"
562,"NULL"
586,"Cloture"
585,"Cloture"
564,
565,"ooufBBPlqznP?IpatHg3P?<vt6>fu`0kU6jBPBjW^iVjWsC]]477uUY`Agaa^n<y\^yY[<jU\F<M8e3XAoDJY0ohHcTx@2d9f?_KWjVSx5dC0[TzYKq7H>`\rCd6\fj4@zN7LhZjYOR>aEMA9n4rfZw8j@Y=SGrzJxBz[Cl7VsMkQGib[1k`0y0v5es>x8K_GEUl=1Wr"
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
560,0
561,0
590,0
637,0
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,115

#****Begin: Generated Statements***
#****End: Generated Statements****


#*****************************************************************************
# CREATEUR : DIMO SOFTWARE: GMU
# DATE DE CREATION : 31/03/2021
# DERNIERE MODIFICATION EFFECTUEE PAR : ...
# DATE DE DERNIERE MODIFICATION : ../../2021.
# DESCRIPTION DU PROCESSUS : Chargement de la chaine d'alimentation et de calcul du cube Ventilation
# 
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

# Gestion du lancement par tÃ¢che planifiÃ©
IF ( SUBST ( TM1User() , 1 , 2 ) @= 'R*' ) ;
	cUtilisateur = 'Lanceur' ;
ELSE ;
	cUtilisateur        = TM1User();

                # Support DImo n°415914 : cas de figure de caractères spéciaux sur le TM1 User
	While (  SCAN( '"', cUtilisateur) <> 0  & SCAN ( ':' , cUtilisateur) <> 0 ) ; 
	    vScan = SCAN( '"', cUtilisateur) ; 
	    cUtilisateur = DELET(cUtilisateur , vScan , 1) ; 
	    vScan = SCAN (':' , cUtilisateur ) ; 
	    cUtilisateur = DELET ( cUtilisateur , vScan , 1) ; 
                End ; 
ENDIF ;

cLenASCIICode = 3 ;

#**********************************************************************************************************
#                                  Définition des variables
#**********************************************************************************************************

StringGlobalVariable('sProcessReturnCode');
NumericGlobalVariable('nProcessReturnCode');

# Pour Ã©changer avec Process.Log.Create
NumericGlobalVariable ('zLogNumero') ; 

# Pour suppression des vues et ss ensemble temporaire
nDebug = 1 ; 

#**********************************************************************************************************
#                                  Initialisation des variables
#**********************************************************************************************************

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

## Définition de la Version et la phase à charger
# Valeurs récupérée dans le cube ParametreF
sVersion = CellGetS ( sCubeParamF , 'VersionReel' , 'ValeurS' ) ; 
sPhase = CellGetS ( sCubeParamF , 'PhaseReel' , 'ValeurS' ) ; 
sAnnee = CellGetS ( sCubeParamF , 'AnneeEnCours' , 'ValeurS' ) ;

#**********************************************************************************************************
#                                  Log start time
#***********************************************************************************************************

ExecuteProcess( 'Process.Log.Create', 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , 'START' ,
	'pV2' , 'Calcul' , 'pV3' , 'Lancement des calculs de ventilation' ) ;

ExecuteProcess ( 'Security_Update_Group', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_User_Group_Right', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_Attr_User_Group') ;
ExecuteProcess ( 'Security_Assign_Direction_Group_Right', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_Nature_Group_Right', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_Cube_Group_Right', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_Process_Group_Right', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_Application_Group_Right_NONE', 'pSecurityRefresh', 0 ) ;
ExecuteProcess ( 'Security_Assign_Application_Group_Right', 'pSecurityRefresh', 1 ) ;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,4

#****Begin: Generated Statements***
#****End: Generated Statements****

575,26

#****Begin: Generated Statements***
#****End: Generated Statements****

IF ( nErrors > 0 ) ;
	nProcessReturnCode = 0 ;
	sProcessReturnCode = Expand( '%sProcessReturnCode% Process:%cMainProcName% aborted. Check log for details.' ) ;
ELSE ;
	sProcessReturnCode  = '' ;
	nProcessReturnCode  = 1 ;
ENDIF ;

#**********************************************************************************************************
#                                 Contrôle des erreurs                                            
#**********************************************************************************************************

ExecuteProcess( 'Process.Log.Create' , 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , 'END' ) ;

ExecuteProcess( 'Process.Log.Create' , 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , If ( GetProcessErrorFilename @= '' , 'OK' , 'KO' ) ,
	'pV1' , 'Process exécuté en ' , 'pV2' , cUtilisateur ) ;

ExecuteProcess( 'Process.Log.Create' , 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , 'BYE' ) ;

IF ( nErrors > 0 ) ;
 ItemReject ( 'Il existe des erreurs dans le chargement de données merci de consulter le cube de log' ) ;
ENDIF ;
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
