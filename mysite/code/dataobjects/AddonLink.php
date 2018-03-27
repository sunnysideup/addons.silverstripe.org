<?php
/**
 * A link from one add-ons to another, such as a requirement dependency.
 */
class AddonLink extends DataObject
{
    public static $db = array(
        'Name' => 'Varchar(100)',
        'Type' => 'Enum(array("require", "require-dev", "suggest", "provide", "conflict", "replace"))',
        'Constraint' => 'Varchar(100)',
        'Description' => 'Varchar(255)'
    );

    public static $has_one = array(
        'Source' => 'AddonVersion',
        'Target' => 'Addon'
    );

    public function Link()
    {
        // if ($this->TargetID) {
        // 	return $this->Target()->Link();
        // }

        if ($this->Name == 'php' || strpos($this->Name, 'ext-') === 0) {
            return '';
        }

        return "https://packagist.org/packages/$this->Name";
    }

    public function ConstraintSimple()
    {
        $constraint = $this->Constraint;
        if ($constraint === '*') {
            return '*';
        }
        $constraint = str_replace(array('>', '=', '~', '<', '*', '^', '@', 'dev', '-', 'v'), '', $constraint);
        $constraint = explode(".", $constraint);
        if (is_array($constraint) && count($constraint)) {
            $v = trim($constraint[0]);
            if (in_array($v, array(2,3,4,5,6,7))) {
                //$secondary = isset($constraint[1]) && strlen($constraint[1]) == 1 ? trim($constraint[1]) : '0';
                return $v; // . '.' . $secondary;
            }
            return 'n/a';
        }
    }
    public function PackageName()
    {
        return $this->getPackageName();
    }
    public function getPackageName()
    {
        return substr($this->Name, strpos($this->Name, '/') + 1);
    }
    public function getPackageNameNice()
    {
        $name = preg_replace('/^'.preg_quote('silverstripe-', '/').'\s*/i', '', $this->getPackageName());
        $name = str_replace(['-', '_'], [' ', ' '], $name);

        return $name;
    }

    public function IsMeaningfull()
    {
        $array = [
            'php'
        ];
        if (in_array($this->Name, $array)) {
            return false;
        }
        
        return true;
    }
}
