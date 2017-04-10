<?php

class TopicChangeIPAddress extends DataObject
{
    private static $db = array(
        'DodgyIP' => 'Boolean',
        'SafeIP' => 'Boolean',
        'IP1' => 'Varchar(70)',
        'IP2' => 'Varchar(70)'
    );
    private static $indexes = array(
        'IP1' => true,
        'IP2' => true
    );

    private static $has_many = array(
        'TopicChanges' => 'TopicChange'
    );

    private static $summary_fields = array(
        'IP1' => 'IP1',
        'IP2' => 'IP2',
        'DodgyIP.Nice' => 'Dodgy IP',
        'SafeIP.Nice' => 'Safe IP'
    );

    public static function find_or_make()
    {
        $filter = array(
            'IP1' => self::get_client_ip_1(),
            'IP2' => self::get_client_ip_2()
        );
        $obj = TopicChangeIPAddress::get()->filter($filter);
        if(! $obj) {
            $obj = TopicChangeIPAddress::create($obj);
            $obj->write();
        }

        return $obj;
    }

    private static function get_client_ip_1() {
        $ipaddress = '';
        if ($x = getenv('HTTP_CLIENT_IP')) {
            $ipaddress = $x;
        } else if($x = getenv('HTTP_X_FORWARDED_FOR')) {
            $ipaddress = $x;
        } else if($x = getenv('HTTP_X_FORWARDED')) {
            $ipaddress = $x;
        } else if($x = getenv('HTTP_FORWARDED_FOR')) {
            $ipaddress = $x;
        } else if($x = getenv('HTTP_FORWARDED')) {
           $ipaddress = $x;
       } else if($x = getenv('REMOTE_ADDR')) {
            $ipaddress = $x;
        } else {
            $ipaddress = 'UNKNOWN';
        }
        return $ipaddress;
    }

    private static function get_client_ip_2() {
        if($x = getenv('REMOTE_ADDR')) {
            $ipaddress = $x;
        }
        else {
            $ipaddress = 'UNKNOWN';
        }
        return $ipaddress;
    }

}
