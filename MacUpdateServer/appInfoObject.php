<?php

define("test-product-id",100);

class appInfoObject{
    protected $_pid;
    protected $_version;
    protected $_releaseNotes;
    protected $_downloadURL;
    protected $_forceUpdateFlag;
    public function __construct($pid, $version, $releaseNotes, $downloadURL, $forceUpdateFlag){
        $this->_pid = $pid;
        $this->_version = $version;
        $this->_releaseNotes = $releaseNotes;
        $this->_downloadURL = $downloadURL;
        $this->_forceUpdateFlag = $forceUpdateFlag;
    }

    public function echoAppInfoJson(){
        $dataArray = array('pid' => $this->_pid, 'ver' => $this->_version, 'notes' => $this->_releaseNotes,'durl' => $this->_downloadURL, 'fuflag' => $this->_forceUpdateFlag);
        $data = json_encode($dataArray,true);
        echo $data;
    }
}
