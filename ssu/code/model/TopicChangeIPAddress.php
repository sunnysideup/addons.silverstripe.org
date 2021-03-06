<?php

class TopicChangeIPAddress extends DataObject
{
    private static $db = array(
        'DodgyIP' => 'Boolean',
        'SafeIP' => 'Boolean',
        'Name' => 'Varchar',
        'IP1' => 'Varchar(70)',
        'IP2' => 'Varchar(70)'
    );
    private static $indexes = array(
        array(
            'type' => 'unique',
            'value' => '"IP1", "IP2"'
        )
    );

    private static $has_many = array(
        'TopicChanges' => 'TopicChange'
    );

    private static $casting = array(
        'Title' => 'Varchar'
    );

    private static $summary_fields = array(
        'IP1' => 'IP1',
        'IP2' => 'IP2',
        'DodgyIP.Nice' => 'Dodgy IP',
        'SafeIP.Nice' => 'Safe IP'
    );

    /**
     * Event handler called before writing to the database.
     */
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();
        if ($this->IsDodgy) {
            $this->IsSafe = false;
        }
    }

    public static function find_or_make()
    {
        $filter = array(
            'IP1' => self::get_client_ip_1(),
            'IP2' => self::get_client_ip_2()
        );
        $obj = TopicChangeIPAddress::get()
            ->filter($filter)
            ->first();
        if (! $obj) {
            $obj = TopicChangeIPAddress::create($obj);
            $obj->write();
        }

        return $obj;
    }

    private static function get_client_ip_1()
    {
        $ipaddress = '';
        if ($x = getenv('HTTP_CLIENT_IP')) {
            $ipaddress = $x;
        } elseif ($x = getenv('HTTP_X_FORWARDED_FOR')) {
            $ipaddress = $x;
        } elseif ($x = getenv('HTTP_X_FORWARDED')) {
            $ipaddress = $x;
        } elseif ($x = getenv('HTTP_FORWARDED_FOR')) {
            $ipaddress = $x;
        } elseif ($x = getenv('HTTP_FORWARDED')) {
            $ipaddress = $x;
        } elseif ($x = getenv('REMOTE_ADDR')) {
            $ipaddress = $x;
        } else {
            $ipaddress = 'UNKNOWN';
        }
        return $ipaddress;
    }

    private static function get_client_ip_2()
    {
        if ($x = getenv('REMOTE_ADDR')) {
            $ipaddress = $x;
        } else {
            $ipaddress = 'UNKNOWN';
        }
        return $ipaddress;
    }

    public function getTitle()
    {
        if ($this->Name) {
            return $this->Name;
        }
        if ($this->IP2 !== $this->IP1) {
            return $this->IP1 . '  -  '.$this->IP2;
        }
        return $this->IP2;
    }

    public function canCreate($member = null)
    {
        return false;
    }

    public function canView($member = null)
    {
        return $this->canEdit($member);
    }

    public function canEdit($member = null)
    {
        if (Permission::checkMember($member, "CMS_ACCESS_EDIT_KEYWORDS")) {
            return true;
        }
        return parent::canEdit($member);
    }

    public function canDelete($member = null)
    {
        return $this->TopicChanges()->count() > 0 ? false : $this->canEdit($member);
    }
}
