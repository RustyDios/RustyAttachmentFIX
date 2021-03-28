You created an XCOM 2 Mod Project!

This is a HOTFIX mod to bridge compatability between these mods;

Culprit:
https://steamcommunity.com/sharedfiles/filedetails/?id=1171964288 Configure Upgrade Slots

Victims:
https://steamcommunity.com/sharedfiles/filedetails/?id=1918448514 Immolator (Chemthrower)
https://steamcommunity.com/sharedfiles/filedetails/?id=1891339003 Cryolator (Chemthrower)
https://steamcommunity.com/sharedfiles/filedetails/?id=1965050975 Xenolator (Chemthrower)
https://steamcommunity.com/sharedfiles/filedetails/?id=1505294997 Psi Gatling Rifle
https://steamcommunity.com/sharedfiles/filedetails/?id=1144417938 Warlock Psionic Reaper

Collateral Damage;
https://steamcommunity.com/sharedfiles/filedetails/?id=1922770319 Alchemist Class
'Psionic Classes'

The issue:

The culprit has a custom function override for 'CanApplyUpgradeToWeapon' which lists a non-dynamic default ranged weapons array, to help sort out ranged from melee weapons
The purpose of this is because the mod lets you configure ANY 'weapon' to have upgrade slots

However Chemthrowers and Psi Rifles have their own unique weapon category and/or range table/settings which fail both of the culprits allowance checks and thus forcing 
	these weapons to not be eligible for upgrades, despite having slots.

This mod overides that behaviour by making the array a dynamic one, adjustable through the config.