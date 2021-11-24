#!/bin/bash

function createFabricante() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/fabricante.autos.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/fabricante.autos.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-fabricante --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-fabricante.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-fabricante.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-fabricante.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-fabricante.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-fabricante --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-fabricante --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-fabricante --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-fabricante --id.name fabricanteadmin --id.secret fabricanteadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-fabricante -M "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/msp" --csr.hosts peer0.fabricante.autos.com --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-fabricante -M "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls" --enrollment.profile tls --csr.hosts peer0.fabricante.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/fabricante.autos.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/tlsca/tlsca.fabricante.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/fabricante.autos.com/ca"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer0.fabricante.autos.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/ca/ca.fabricante.autos.com-cert.pem"


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-fabricante -M "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/msp" --csr.hosts peer1.fabricante.autos.com --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/msp/config.yaml"

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-fabricante -M "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls" --enrollment.profile tls --csr.hosts peer1.fabricante.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/fabricante.autos.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/tlsca/tlsca.fabricante.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/fabricante.autos.com/ca"
  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/peers/peer1.fabricante.autos.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/fabricante.autos.com/ca/ca.fabricante.autos.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-fabricante -M "${PWD}/organizations/peerOrganizations/fabricante.autos.com/users/User1@fabricante.autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/fabricante.autos.com/users/User1@fabricante.autos.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://fabricanteadmin:fabricanteadminpw@localhost:7054 --caname ca-fabricante -M "${PWD}/organizations/peerOrganizations/fabricante.autos.com/users/Admin@fabricante.autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/fabricante/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/fabricante.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/fabricante.autos.com/users/Admin@fabricante.autos.com/msp/config.yaml"
}

function createTransportista() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/transportista.autos.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/transportista.autos.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-transportista --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-transportista.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-transportista.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-transportista.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-transportista.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/transportista.autos.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-transportista --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-transportista --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-transportista --id.name transportistaadmin --id.secret transportistaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-transportista -M "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/msp" --csr.hosts peer0.transportista.autos.com --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-transportista -M "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls" --enrollment.profile tls --csr.hosts peer0.transportista.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/transportista.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/transportista.autos.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/transportista.autos.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/transportista.autos.com/tlsca/tlsca.transportista.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/transportista.autos.com/ca"
  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/peers/peer0.transportista.autos.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/transportista.autos.com/ca/ca.transportista.autos.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-transportista -M "${PWD}/organizations/peerOrganizations/transportista.autos.com/users/User1@transportista.autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/transportista.autos.com/users/User1@transportista.autos.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://transportistaadmin:transportistaadminpw@localhost:8054 --caname ca-transportista -M "${PWD}/organizations/peerOrganizations/transportista.autos.com/users/Admin@transportista.autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/transportista/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/transportista.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/transportista.autos.com/users/Admin@transportista.autos.com/msp/config.yaml"
}

function createConcesionario() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/concesionario.autos.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/concesionario.autos.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca-concesionario --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-concesionario.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-concesionario.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-concesionario.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-concesionario.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/concesionario.autos.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-concesionario --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-concesionario --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-concesionario --id.name concesionarioadmin --id.secret concesionarioadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-concesionario -M "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/msp" --csr.hosts peer0.concesionario.autos.com --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-concesionario -M "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls" --enrollment.profile tls --csr.hosts peer0.concesionario.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/concesionario.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/concesionario.autos.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/concesionario.autos.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/concesionario.autos.com/tlsca/tlsca.concesionario.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/concesionario.autos.com/ca"
  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/peers/peer0.concesionario.autos.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/concesionario.autos.com/ca/ca.concesionario.autos.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-concesionario -M "${PWD}/organizations/peerOrganizations/concesionario.autos.com/users/User1@concesionario.autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/concesionario.autos.com/users/User1@concesionario.autos.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://concesionarioadmin:concesionarioadminpw@localhost:6054 --caname ca-concesionario -M "${PWD}/organizations/peerOrganizations/concesionario.autos.com/users/Admin@concesionario.autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/concesionario/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/concesionario.autos.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/concesionario.autos.com/users/Admin@concesionario.autos.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/autos.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/autos.com

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
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/autos.com/msp/config.yaml"

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
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/msp" --csr.hosts orderer.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls" --enrollment.profile tls --csr.hosts orderer.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/msp/tlscacerts/tlsca.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/msp/tlscacerts/tlsca.autos.com-cert.pem"


  infoln "Generating the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/msp" --csr.hosts orderer2.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/msp/config.yaml"

  infoln "Generating the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls" --enrollment.profile tls --csr.hosts orderer2.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/msp/tlscacerts/tlsca.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer2.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/msp/tlscacerts/tlsca.autos.com-cert.pem"


  infoln "Generating the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/msp" --csr.hosts orderer3.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/msp/config.yaml"

  infoln "Generating the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls" --enrollment.profile tls --csr.hosts orderer3.autos.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/msp/tlscacerts/tlsca.autos.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/autos.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/autos.com/orderers/orderer3.autos.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/autos.com/msp/tlscacerts/tlsca.autos.com-cert.pem"


  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/autos.com/users/Admin@autos.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/autos.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/autos.com/users/Admin@autos.com/msp/config.yaml"
}
