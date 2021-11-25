#!/bin/bash

function createEmpresa() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/empresa.pi.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/empresa.pi.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-empresa --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-empresa.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-empresa.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-empresa.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-empresa.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-empresa --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-empresa --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-empresa --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-empresa --id.name empresaadmin --id.secret empresaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-empresa -M "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/msp" --csr.hosts peer0.empresa.pi.com --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-empresa -M "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls" --enrollment.profile tls --csr.hosts peer0.empresa.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/empresa.pi.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/tlsca/tlsca.empresa.pi.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/empresa.pi.com/ca"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer0.empresa.pi.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/ca/ca.empresa.pi.com-cert.pem"


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-empresa -M "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/msp" --csr.hosts peer1.empresa.pi.com --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/msp/config.yaml"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-empresa -M "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls" --enrollment.profile tls --csr.hosts peer1.empresa.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/empresa.pi.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/tlsca/tlsca.empresa.pi.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/empresa.pi.com/ca"
  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/peers/peer1.empresa.pi.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/empresa.pi.com/ca/ca.empresa.pi.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-empresa -M "${PWD}/organizations/peerOrganizations/empresa.pi.com/users/User1@empresa.pi.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/empresa.pi.com/users/User1@empresa.pi.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://empresaadmin:empresaadminpw@localhost:7054 --caname ca-empresa -M "${PWD}/organizations/peerOrganizations/empresa.pi.com/users/Admin@empresa.pi.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/empresa/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/empresa.pi.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/empresa.pi.com/users/Admin@empresa.pi.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/pi.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/pi.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/pi.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering orderer3"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/msp" --csr.hosts orderer.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls" --enrollment.profile tls --csr.hosts orderer.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/msp/tlscacerts/tlsca.pi.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/msp/tlscacerts/tlsca.pi.com-cert.pem"


  infoln "Generating the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/msp" --csr.hosts orderer2.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/msp/config.yaml"

  infoln "Generating the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls" --enrollment.profile tls --csr.hosts orderer2.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/msp/tlscacerts/tlsca.pi.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer2.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/msp/tlscacerts/tlsca.pi.com-cert.pem"


  infoln "Generating the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/msp" --csr.hosts orderer3.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/msp/config.yaml"

  infoln "Generating the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls" --enrollment.profile tls --csr.hosts orderer3.pi.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/msp/tlscacerts/tlsca.pi.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/pi.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/pi.com/orderers/orderer3.pi.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/pi.com/msp/tlscacerts/tlsca.pi.com-cert.pem"


  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/pi.com/users/Admin@pi.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/pi.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/pi.com/users/Admin@pi.com/msp/config.yaml"
}
