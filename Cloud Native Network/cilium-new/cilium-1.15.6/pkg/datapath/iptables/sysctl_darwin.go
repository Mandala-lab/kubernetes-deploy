// SPDX-License-Identifier: Apache-2.0
// Copyright Authors of Cilium

package iptables

// enableIPForwarding on OS X and Darwin is not doing anything. It just exists
// to make compilation possible.
func enableIPForwarding(_ bool) error {
	return nil
}
