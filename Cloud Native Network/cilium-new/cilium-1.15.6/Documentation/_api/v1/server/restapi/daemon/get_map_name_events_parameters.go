// Code generated by go-swagger; DO NOT EDIT.

// Copyright Authors of Cilium
// SPDX-License-Identifier: Apache-2.0

package daemon

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"net/http"

	"github.com/go-openapi/errors"
	"github.com/go-openapi/runtime"
	"github.com/go-openapi/runtime/middleware"
	"github.com/go-openapi/strfmt"
	"github.com/go-openapi/swag"
)

// NewGetMapNameEventsParams creates a new GetMapNameEventsParams object
//
// There are no default values defined in the spec.
func NewGetMapNameEventsParams() GetMapNameEventsParams {

	return GetMapNameEventsParams{}
}

// GetMapNameEventsParams contains all the bound params for the get map name events operation
// typically these are obtained from a http.Request
//
// swagger:parameters GetMapNameEvents
type GetMapNameEventsParams struct {

	// HTTP Request Object
	HTTPRequest *http.Request `json:"-"`

	/*Whether to follow streamed requests
	  In: query
	*/
	Follow *bool
	/*Name of map
	  Required: true
	  In: path
	*/
	Name string
}

// BindRequest both binds and validates a request, it assumes that complex things implement a Validatable(strfmt.Registry) error interface
// for simple values it will use straight method calls.
//
// To ensure default values, the struct must have been initialized with NewGetMapNameEventsParams() beforehand.
func (o *GetMapNameEventsParams) BindRequest(r *http.Request, route *middleware.MatchedRoute) error {
	var res []error

	o.HTTPRequest = r

	qs := runtime.Values(r.URL.Query())

	qFollow, qhkFollow, _ := qs.GetOK("follow")
	if err := o.bindFollow(qFollow, qhkFollow, route.Formats); err != nil {
		res = append(res, err)
	}

	rName, rhkName, _ := route.Params.GetOK("name")
	if err := o.bindName(rName, rhkName, route.Formats); err != nil {
		res = append(res, err)
	}
	if len(res) > 0 {
		return errors.CompositeValidationError(res...)
	}
	return nil
}

// bindFollow binds and validates parameter Follow from query.
func (o *GetMapNameEventsParams) bindFollow(rawData []string, hasKey bool, formats strfmt.Registry) error {
	var raw string
	if len(rawData) > 0 {
		raw = rawData[len(rawData)-1]
	}

	// Required: false
	// AllowEmptyValue: false

	if raw == "" { // empty values pass all other validations
		return nil
	}

	value, err := swag.ConvertBool(raw)
	if err != nil {
		return errors.InvalidType("follow", "query", "bool", raw)
	}
	o.Follow = &value

	return nil
}

// bindName binds and validates parameter Name from path.
func (o *GetMapNameEventsParams) bindName(rawData []string, hasKey bool, formats strfmt.Registry) error {
	var raw string
	if len(rawData) > 0 {
		raw = rawData[len(rawData)-1]
	}

	// Required: true
	// Parameter is provided by construction from the route
	o.Name = raw

	return nil
}
