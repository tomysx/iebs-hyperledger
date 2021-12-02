package main

import (
  "encoding/json"
  "fmt"
  "log"
  "time"

  "github.com/golang/protobuf/ptypes"
  "github.com/satori/go.uuid"
  "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
      contractapi.Contract
    }

type Alumno struct {
      ID             string `json:"ID"`
      Nombre             string `json:"nombre"`
      Carrera    string    `json:"carrera"`
      Extradata      string `json:"extradata"`
	}

	type HistoryQueryResult struct {
		Record    *Alumno    `json:"record"`
		TxId     string    `json:"txId"`
		Timestamp time.Time `json:"timestamp"`
		IsDelete  bool      `json:"isDelete"`
	}

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {

	myuuids := uuid.NewV4().String()
	fmt.Println("Your UUID is:", myuuids)

	myuuid2 := uuid.NewV4().String()
	fmt.Println("Your UUID2 is:", myuuid2)
	
    alumnos := []Alumno{
      {ID: myuuids, Nombre: "Alfonso", Carrera: "Derecho", Extradata: "No tiene postgrado oficial en ninguna universidad"},
      {ID: myuuid2, Nombre: "Felipe", Carrera: "Periodismo", Extradata: "Tiene un máster privado en periodismo deportivo"},
    }
    for _, alumno := range alumnos {
      alumnoJSON, err := json.Marshal(alumno)
      if err != nil {
        return err
      }
    
      err = ctx.GetStub().PutState(alumno.ID, alumnoJSON)
      if err != nil {
        return fmt.Errorf("failed to put to world state. %v", err)
      }
    }

    return nil
  }

func (s *SmartContract) CreateAlumno(ctx contractapi.TransactionContextInterface, nombre string, carrera string, extradata string) error {

	myuuid := uuid.NewV4().String()
	fmt.Println("Nuevo alumno UUID:", myuuid)

    alumno := Alumno{
      ID:          myuuid,
      Nombre:          nombre,
      Carrera: carrera,
      Extradata:   extradata,
    }
    alumnoJSON, err := json.Marshal(alumno)
    if err != nil {
      return err
    }

    return ctx.GetStub().PutState(myuuid, alumnoJSON)
  }

// ReadAlumno devuelve el Alumno almacenado en el World State con su última modificación
   func (s *SmartContract) ReadAlumno(ctx contractapi.TransactionContextInterface, id string) (*Alumno, error) {
    alumnoJSON, err := ctx.GetStub().GetState(id)
    if err != nil {
      return nil, fmt.Errorf("Error al leer de Fabric: %v", err)
    }
    if alumnoJSON == nil {
      return nil, fmt.Errorf("El alumno %s no existe", id)
    }

    var alumno Alumno
    err = json.Unmarshal(alumnoJSON, &alumno)
    if err != nil {
      return nil, err
    }

    return &alumno, nil
  }

func (s *SmartContract) UpdateAlumno(ctx contractapi.TransactionContextInterface, id string, nombre string, carrera string, extradata string) error {
  exists, err := s.AlumnoExists(ctx, id)
  if err != nil {
      return err
    }
  if !exists {
      return fmt.Errorf("El alumno %s no existe", id)
    }

  alumno := Alumno{
      ID:          id,
      Nombre:          nombre,
      Carrera: carrera,
      Extradata:   extradata,
    }
  
  alumnoJSON, err := json.Marshal(alumno)
  
  if err != nil {
      return err
    }

    return ctx.GetStub().PutState(id, alumnoJSON)
  }

  // DeleteAlumno elimina a un Alumno del world state
  func (s *SmartContract) DeleteAlumno(ctx contractapi.TransactionContextInterface, id string) error {
    exists, err := s.AlumnoExists(ctx, id)
    if err != nil {
      return err
    }
    if !exists {
      return fmt.Errorf("the alumno %s does not exist", id)
    }

    return ctx.GetStub().DelState(id)
  }

// AlumnoExists devuelve un true si existe el ID del Alumno consultado
   func (s *SmartContract) AlumnoExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
    alumnoJSON, err := ctx.GetStub().GetState(id)
    if err != nil {
      return false, fmt.Errorf("failed to read from world state: %v", err)
    }

    return alumnoJSON != nil, nil
  }



// StatusAlumno actualiza datos extra del Alumno en el world state
func (s *SmartContract) StatusAlumno(ctx contractapi.TransactionContextInterface, id string, extradata string) error {
    alumno, err := s.ReadAlumno(ctx, id)
    if err != nil {
      return err
    }

    alumno.Extradata = extradata
    alumnoJSON, err := json.Marshal(alumno)
    if err != nil {
      return err
    }

    return ctx.GetStub().PutState(id, alumnoJSON)
  }

// GetAllAlumnos devuelve todos los Alumnos del world state
   func (s *SmartContract) GetAllAlumnos(ctx contractapi.TransactionContextInterface) ([]*Alumno, error) {
    resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
    if err != nil {
      return nil, err
    }
    defer resultsIterator.Close()

    var alumnos []*Alumno
    for resultsIterator.HasNext() {
      queryResponse, err := resultsIterator.Next()
      if err != nil {
        return nil, err
      }

      var alumno Alumno
      err = json.Unmarshal(queryResponse.Value, &alumno)
      if err != nil {
        return nil, err
      }
      alumnos = append(alumnos, &alumno)
    }

    return alumnos, nil
  }

// GetAlumnoHistory devuelve la información histórica custodiada por el ledger
func (t *SmartContract) GetAlumnoHistory(ctx contractapi.TransactionContextInterface, alumnoID string) ([]HistoryQueryResult, error) {
	log.Printf("GetAlumnoHistory: ID %v", alumnoID)

	resultsIterator, err := ctx.GetStub().GetHistoryForKey(alumnoID)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var records []HistoryQueryResult
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var alumno Alumno
		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &alumno)
			if err != nil {
				return nil, err
			}
		} else {
			alumno = Alumno{
				ID: alumnoID,
			}
		}

		timestamp, err := ptypes.Timestamp(response.Timestamp)
		if err != nil {
			return nil, err
		}

		record := HistoryQueryResult{
			TxId:      response.TxId,
			Timestamp: timestamp,
			Record:    &alumno,
			IsDelete:  response.IsDelete,
		}
		records = append(records, record)
	}

	return records, nil
}

  func main() {
    alumnoChaincode, err := contractapi.NewChaincode(&SmartContract{})
    if err != nil {
      log.Panicf("Error creating alumno-transfer-basic chaincode: %v", err)
    }

    if err := alumnoChaincode.Start(); err != nil {
      log.Panicf("Error starting alumno-transfer-basic chaincode: %v", err)
    }
  }