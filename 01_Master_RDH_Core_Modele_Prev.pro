601,100
602,"01_Master_RDH_Core_Modele_Prev"
562,"NULL"
586,"Cloture"
585,"Cloture"
564,
565,"u53Nis`58RDFiMkxdNb1xa@vgFw:hyw2UytZ]17l7k[t[dXINcx[NQbou7t`L[?Aw6F^?CAUXM@Q<o]VLxq[hwdj:ow02IV4utGD:epTK<]@cLQZJ@4z>GQ_50=us0>JuHq:y[SzuL8k60[1CV?WP:h9EWVBy^_T=L;DX4rpM?aE5foX4jPe1nBP9O4^ZrJotTb9FDkb"
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
pMois
pAnnee
561,2
2
2
590,2
pMois,""
pAnnee,""
637,2
pMois,"Vide : mois en cours / * : tous les mois / MXX : mois défini"
pAnnee,"Vide : année en cours / * : tous les années / EXX : année définie"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,160

#****Begin: Generated Statements***
#****End: Generated Statements****

#*****************************************************************************
# CREATEUR : DIMO SOFTWARE: RCU
# DATE DE CREATION : 27/07/2021
# DERNIERE MODIFICATION EFFECTUEE PAR : ...
# DATE DE DERNIERE MODIFICATION : ../../2021.
# DESCRIPTION DU PROCESSUS : Chargement de la chaine d'alimentation jusqu'au cube PL_SAISIE
# Exécution des procesus 
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

#**********************************************************************************************************
#                                  Log start time
#***********************************************************************************************************

ExecuteProcess( 'Process.Log.Create', 'pProcesses' , cMainProcName , 'pDateExec' , cTimeProcess , 'pNumero' , zLogNumero , 'pType' , 'LOG' , 'pStatus' , 'START' ,
	'pV2' , 'Calcul' , 'pV3' , 'Lancement du chargement du cube PL_Saisie' ) ;

#**********************************************************************************************************
#                                  Initialisation des variables techniques 
#**********************************************************************************************************
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

#**********************************************************************************************************
#                                  Test du mois
#***********************************************************************************************************

If ( pMois @= '' ) ; 
	pMois = CellGetS ( sCubeParamF , 'MoisEnCours' , 'ValeurS' ) ; 
EndIf ; 
If ( pAnnee @= '' ) ;
	pAnnee = CellGetS ( sCubeParamF , 'AnneeEnCours' , 'ValeurS' ) ;
EndIf ; 

If ( DimIx ( 'Mois' , pMois ) = 0 & pMois @<> '*' ) ;
	ProcessBreak ;
EndIf ; 

If ( DimIx ( 'Annee' , pAnnee )=0 & pAnnee @<> '*' ) ;
	ProcessBreak ;
EndIf ; 

#**********************************************************************************************************
#                                  Lancement de l'éxécution des processsus
#**********************************************************************************************************

# Boucle pour importer les données paramétrées : 
# Si le mois est vide, seulement le mois et l'année en cours.
# Si le mois est paramétré, le mois paramétré de l'année en cours
# Si le mois est égal à *, tous les mois de toutes les années.

If ( pAnnee @<> '*' ) ; 
	nBoucleAnnee = DimIx ( 'Annee' , pAnnee ) ;
	nIncAnnee = nBoucleAnnee ; 
Else ;
	nBoucleAnnee = DimSiz ( 'Annee' ) ;
	nIncAnnee = 1 ; 
EndIf ; 

While ( nIncAnnee <= nBoucleAnnee ) ;
	sAnnee = DimNm ( 'Annee' , nIncAnnee ) ;

	If ( ElLev ( 'Annee' , sAnnee ) = 0 ) ;

		If ( pMois @<> '*' ) ; 
			nBoucleMois = DimIx ( 'Mois' , pMois ) ;
			nIncMois = nBoucleMois ; 
		Else ;
			nBoucleMois = DimSiz ( 'Mois' ) ;
			nIncMois = 1 ; 
		EndIf ;

		While ( nIncMois <= nBoucleMois ) ; 

			sMois = DimNm ( 'Mois' , nIncMois ) ; 
			If ( ElLev ( 'Mois' , sMois ) = 0 )  ; 
ASCIIOUTPUT('.\RCU.txt', sAnnee, sMois) ;
				# Chargement des données du cube PL vers le cube PL_Saisie 
				ExecuteProcess ( 'MAJ_Data_PL_Saisie_PL_Reel' , 'pAnnee' , sAnnee , 'pMois' , sMois ) ;

			EndIf ; 

			nIncMois = nIncMois + 1 ; 

		End ;

	EndIf ; 

	nIncAnnee = nIncAnnee +1 ;
End ; 
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,8

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

IF ( nErrors > 0 % nDataCount > 0 ) ;
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
