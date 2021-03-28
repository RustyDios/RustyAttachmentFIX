//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_RustyImmolatorAttachmentFIX.uc                                    
//
//	File created by RustyDios	29/11/19	21:00	
//	LAST UPDATED				17/03/20	12:30
//
//  HOTFIX Mod for Configureable Upgrade Slots mod
//
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_RustyImmolatorAttachmentFIX extends X2DownloadableContentInfo config (RIAFConfig);

//define a new structure type for configuring images for weapons
//taken from MERC/ EU Plasma weapons
struct WeaponAttachment {
	var string Type;
	var name AttachSocket;
	var name UIArmoryCameraPointTag;
	var string MeshName;
	var string ProjectileName;
	var name MatchWeaponTemplate;
	var bool AttachToPawn;
	var string IconName;
	var string InventoryIconName;
	var string InventoryCategoryIcon;
	var name AttachmentFn;
};

//grab some config stuffs 
var config array<WeaponAttachment> NewAttachmentsSetups;
var config array<name> DefaultRangedWeaponCategories;

var config bool bEnableLogging;

//perform the actions in an OPTC script
static event OnPostTemplatesCreated()
{
	AddNewAttachmentsSetups();

	UpdateAttachmentUpgrades();

}

//---------------------------------------------------------------------------------------
//	CHEMTHROWER ATTACHMENTS
//---------------------------------------------------------------------------------------

//add new attachments and images
static function AddNewAttachmentsSetups()
{
	local array<name> AttachmentTypes;
	local name AttachmentType;
	
	//AutoLoaders
	AttachmentTypes.AddItem('ReloadUpgrade_Bsc');
	AttachmentTypes.AddItem('ReloadUpgrade_Adv');
	AttachmentTypes.AddItem('ReloadUpgrade_Sup');

	//Extended Mags
	AttachmentTypes.AddItem('ClipSizeUpgrade_Bsc');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Adv');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Sup');

	//Stocks
	AttachmentTypes.AddItem('MissDamageUpgrade_Bsc');
	AttachmentTypes.AddItem('MissDamageUpgrade_Adv');
	AttachmentTypes.AddItem('MissDamageUpgrade_Sup');

	//Hair Triggers
	AttachmentTypes.AddItem('FreeFireUpgrade_Bsc');
	AttachmentTypes.AddItem('FreeFireUpgrade_Adv');
	AttachmentTypes.AddItem('FreeFireUpgrade_Sup');

	//Repeaters
	AttachmentTypes.AddItem('FreeKillUpgrade_Bsc');
	AttachmentTypes.AddItem('FreeKillUpgrade_Adv');
	AttachmentTypes.AddItem('FreeKillUpgrade_Sup');

	//Laser Sights
	AttachmentTypes.AddItem('CritUpgrade_Bsc');
	AttachmentTypes.AddItem('CritUpgrade_Adv');
	AttachmentTypes.AddItem('CritUpgrade_Sup');

	//Scopes
	AttachmentTypes.AddItem('AimUpgrade_Bsc');
	AttachmentTypes.AddItem('AimUpgrade_Adv');
	AttachmentTypes.AddItem('AimUpgrade_Sup');

	//cycle through them all and add the correct interactions
	foreach AttachmentTypes(AttachmentType)
	{
		AddNewAttachmentsSetup(AttachmentType, default.NewAttachmentsSetups);
	}
}

//create the unique attachment interactions
//also stolen from MERC / EU Plasma
static function AddNewAttachmentsSetup(name TemplateName, array<WeaponAttachment> Attachments) 
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponUpgradeTemplate Template;
	local WeaponAttachment Attachment;
	local delegate<X2TacticalGameRulesetDataStructures.CheckUpgradeStatus> CheckFN;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	
	foreach Attachments(Attachment)
	{
		if (InStr(string(TemplateName), Attachment.Type) != INDEX_NONE)
		{
			switch(Attachment.AttachmentFn) 
			{
				case ('NoReloadUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent; 
					break;
				case ('ReloadUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.ReloadUpgradePresent; 
					break;
				case ('NoClipSizeUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent; 
					break;
				case ('ClipSizeUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent; 
					break;
				case ('NoFreeFireUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.NoFreeFireUpgradePresent; 
					break;
				case ('FreeFireUpgradePresent'): 
					CheckFN = class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent; 
					break;
				default:
					CheckFN = none;
					break;
			}
			Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.MeshName, Attachment.ProjectileName, Attachment.MatchWeaponTemplate, Attachment.AttachToPawn, Attachment.IconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, CheckFN);
		}
	}
}

//---------------------------------------------------------------------------------------
//	CONFIGURE UPGRADES OVERRIDE
//---------------------------------------------------------------------------------------

//OPTC PATCH to ALL attachments to change how they can be attached
//overrides musashi's function with my own
static function UpdateAttachmentUpgrades()
{
		local X2ItemTemplateManager		ItemTemplateMananger;
		local array<X2DataTemplate>		Templates;
		local X2DataTemplate			Template;

		local array<name>				TemplateNames;
		local name						TemplateName;
		local X2WeaponUpgradeTemplate	UpgradeTemplate;

		ItemTemplateMananger = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		ItemTemplateMananger.GetTemplateNames(TemplateNames);

		foreach TemplateNames(TemplateName)
		{
			ItemTemplateMananger.FindDataTemplateAllDifficulties(TemplateName, Templates);

			foreach Templates(Template)
			{
				UpgradeTemplate = X2WeaponUpgradeTemplate(Template);
				if (UpgradeTemplate == none)
					continue;

				if (InStr(string(UpgradeTemplate.DataName), "AimUpgrade") != INDEX_NONE ||
					InStr(string(UpgradeTemplate.DataName), "FreeFireUpgrade") != INDEX_NONE ||
					InStr(string(UpgradeTemplate.DataName), "MissDamageUpgrade") != INDEX_NONE ||
					InStr(string(UpgradeTemplate.DataName), "FreeKillUpgrade") != INDEX_NONE ||
					InStr(string(UpgradeTemplate.DataName), "CritUpgrade") != INDEX_NONE ||
					InStr(string(UpgradeTemplate.DataName), "ClipSizeUpgrade") != INDEX_NONE ||
					InStr(string(UpgradeTemplate.DataName), "ReloadUpgrade") != INDEX_NONE)
				{
					UpgradeTemplate.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponPatched_Rusty;
					`LOG("Patch" @ UpgradeTemplate.DataName @ "CanApplyUpgradeToWeaponFn",default.bEnableLogging, 'ConfigureUpgradeSlots_RustyCategoryFIX');
				}
			}
		}
}

//OPTC PATCH to ALL attachments to change how they can be attached
//overrides musashi's function with my own using a dynamic/config array instead of a hardcoded one
static function bool CanApplyUpgradeToWeaponPatched_Rusty(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local X2WeaponTemplate WeaponTemplate;
	//local array<name> DefaultRangedWeaponCategories;
	// // var config array<name> DefaultRangedWeaponCategories; // // grabbed above instead

	WeaponTemplate = X2WeaponTemplate(Weapon.GetMyTemplate());

	//DefaultRangedWeaponCategories.AddItem('pistol');
	//DefaultRangedWeaponCategories.AddItem('rifle');
	//DefaultRangedWeaponCategories.AddItem('shotgun');
	//DefaultRangedWeaponCategories.AddItem('cannon');
	//DefaultRangedWeaponCategories.AddItem('sniper_rifle');
	//DefaultRangedWeaponCategories.AddItem('vektor_rifle');
	//DefaultRangedWeaponCategories.AddItem('bullpup');
	//DefaultRangedWeaponCategories.AddItem('sidearm');

	`LOG(default.Class.Name @ GetFuncName() @ WeaponTemplate.DataName,default.bEnableLogging, 'ConfigureUpgradeSlots_RustyCategoryFIX');
	`LOG(default.Class.Name @ GetFuncName() @ WeaponTemplate.RangeAccuracy.Length @ WeaponTemplate.iRange @ "template range values",default.bEnableLogging, 'ConfigureUpgradeSlots_RustyCategoryFIX');

	if (WeaponTemplate != none && WeaponTemplate.RangeAccuracy.Length > 0 && WeaponTemplate.iRange == INDEX_NONE)
	{
		return class'X2Item_DefaultUpgrades'.static.CanApplyUpgradeToWeapon(UpgradeTemplate, Weapon, SlotIndex);
	}

	`LOG(default.Class.Name @ GetFuncName() @ WeaponTemplate.WeaponCat @ "template weapon cat",default.bEnableLogging, 'ConfigureUpgradeSlots_RustyCategoryFIX');

	if (WeaponTemplate != none && default.DefaultRangedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
	{
		return class'X2Item_DefaultUpgrades'.static.CanApplyUpgradeToWeapon(UpgradeTemplate, Weapon, SlotIndex);
	}

	`LOG(GetFuncName() @ "Template :: " @ WeaponTemplate.DataName @ " :: Category :: " @ WeaponTemplate.WeaponCat @ " :: Not set as a DefaultRangedWeapon :: Fail ",default.bEnableLogging, 'ConfigureUpgradeSlots_RustyCategoryFIX');
	return false;
}

//---------------------------------------------------------------------------------------
//	END OPTC SCRIPT
//---------------------------------------------------------------------------------------
