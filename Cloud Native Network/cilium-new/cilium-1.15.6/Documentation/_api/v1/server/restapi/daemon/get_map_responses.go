// Code generated by go-swagger; DO NOT EDIT.

// Copyright Authors of Cilium
// SPDX-License-Identifier: Apache-2.0

package daemon

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"net/http"

	"github.com/go-openapi/runtime"

	"github.com/cilium/cilium/api/v1/models"
)

// GetMapOKCode is the HTTP code returned for type GetMapOK
const GetMapOKCode int = 200

/*
GetMapOK Success

swagger:response getMapOK
*/
type GetMapOK struct {

	/*
	  In: Body
	*/
	Payload *models.BPFMapList `json:"body,omitempty"`
}

// NewGetMapOK creates GetMapOK with default headers values
func NewGetMapOK() *GetMapOK {

	return &GetMapOK{}
}

// WithPayload adds the payload to the get map o k response
func (o *GetMapOK) WithPayload(payload *models.BPFMapList) *GetMapOK {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the get map o k response
func (o *GetMapOK) SetPayload(payload *models.BPFMapList) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *GetMapOK) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(200)
	if o.Payload != nil {
		payload := o.Payload
		if err := producer.Produce(rw, payload); err != nil {
			panic(err) // let the recovery middleware deal with this
		}
	}
}
