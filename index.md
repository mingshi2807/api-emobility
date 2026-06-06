# VEDECOM eMobility APIs

This repository contains the VEDECOM eMobility API specifications used to describe services, protocol adapters, simulation tools, charging infrastructure interfaces, and Plug and Charge certificate services.

The specifications are intended for software teams that need to understand, implement, integrate, or review VEDECOM eMobility interfaces. They describe HTTP APIs, WebSocket exchanges, protocol-oriented payloads, security requirements, schemas, examples, and the expected behavior of each API family.

## Audience

Use these specifications if you are:

- Building client applications that consume VEDECOM eMobility services.
- Implementing backend services that expose compatible endpoints.
- Integrating charge points, charging station management systems, energy managers, or certificate services.
- Reviewing the API contracts before development, deployment, testing, or partner onboarding.
- Generating client or server code from the API descriptions when the target specification is suitable for generation.

## Specification Families

### ERM Platform

The ERM platform specification describes the VEDECOM eMobility Resource Management API. It provides a unified surface for:

- IAM: tenants, users, roles, and policies.
- Catalog: software enablers, assets, and taxonomy.
- Releases: versions, changelogs, and artifacts.

This API is designed as a versioned platform service and uses OAuth2 scopes for read and write access.

### HEMS

The HEMS-SCPA specification describes Home Energy Management System interfaces for local energy coordination around charging equipment. It includes:

- A WebSocket channel for real-time bidirectional communication.
- An OCPP proxy WebSocket interface for charge point connectivity.
- MQTT-oriented site energy data topics for PV, grid, household, and runtime input.
- Configuration concepts for protocol selection, site input, and simulation modes.

This family is relevant for local energy management, smart charging coordination, and integration with EEBUS or OCPP-capable equipment.

### BOBC Remote Control

The BOBC specification describes a Bidirectional On Board Charger remote-control interface. It covers:

- Charger configuration.
- Charge and discharge parameters.
- Active and reactive power setpoints.
- Operational status values.

This API is intended for systems that need to monitor or command bidirectional charger behavior during charging and discharging scenarios.

### CSMS, OCPP, and OCPI

The CSMS REST API describes Charging Station Management System functionality with support for OCPP 2.0.1, OCPP 2.1, and OCPI 2.2.1 operations.

It includes:

- User authentication and CSMS administration.
- Charging station and EVSE management.
- OCPP operations for remote transaction control, reset, availability, variable access, certificate operations, and charging profiles.
- OCPI registration, credentials, version discovery, sessions, and charging-profile interactions.

This specification is useful for CPO backends, interoperability testing, CSMS integrations, and roaming-related workflows.

### OpenADR / DSO-CPO Interface

The OpenADR family describes a DSO-CPO interface for grid-aware charging and demand-response scenarios. It is based on OpenADR 3 concepts and adds constraints for the documented DSO-CPO use case.

The API includes operations for:

- VEN management.
- Program management.
- Event management.
- Demand-response communication between grid-side and charging-side actors.

Important: this specification contains use-case-specific constraints. Review the compliance notes inside the specification before using it for generic OpenADR 3 client or server generation.

### EV Virtualizer

The EV Virtualizer specification describes an API for simulating and controlling electric vehicle behavior. It includes endpoints for:

- Charge status and measured power.
- Authorization state.
- Charging targets and schedules.
- Plug and unplug simulation.
- Contract certificate selection.
- Meter values.
- Configuration and system control.

This API is useful for test benches, integration validation, charge-flow simulation, and scenarios where a physical EV is not available.

### Charge Point APIs

The charge point specifications describe HTTP and WebSocket-facing interfaces implemented around charging station behavior.

The main charge-point inventory covers:

- Charging state and charge limits.
- Configuration and system information.
- IEC 61851 and CCS-related observations.
- ISO 15118 controlling modules.
- Charge broker data.
- EMS coordination.
- Broadcast-only WebSocket notifications for selected events and measurements.

Additional charge-point specifications cover more focused surfaces:

- ComboCS core access.
- EVSE ComboCS access.
- EVSE charge broker data.
- EVSE EMS control.

These APIs are relevant for charging station control, embedded integration, remote inspection, and test environments.

### Plug and Charge PKI Services

The PKI specifications describe Plug and Charge certificate services and related event payloads. They include:

- PKI API: certificate authority services, certificate chains, enrollment, and revocation.
- CCP API: Contract Certificate Pool services for contract data and signed contract data.
- CPS API: Contract Provisioning Service operations for generating and signing contract data.
- PCP API: Provisioning Certificate Pool operations for vehicle provisioning certificates.
- RCP API: Root Certificate Pool operations for root certificate management.
- Event API: webhook endpoint management for certificate-related notifications.
- Webhook payload schemas: event payload definitions for root certificate, provisioning, contract, and related changes.

These APIs are relevant for ISO 15118 Plug and Charge ecosystems, eMSP/CPO/OEM backend integration, certificate lifecycle management, and ecosystem event notification.

## How the Repository Is Organized

The API specifications are grouped by product or protocol domain:

- `ERM/` for the ERM platform API.
- `HEMS/` for Home Energy Management System interfaces.
- `OBC/` for Bidirectional On Board Charger control.
- `OCPP_OCPI/` for CSMS, OCPP, and OCPI operations.
- `OpenADR/` for DSO-CPO grid-aware charging interfaces.
- `ev-virtualizer/` for EV simulation and control.
- `charge-point/` for charging station and EVSE APIs.
- `PKI/` for Plug and Charge certificate services.
- `components/` for shared schema material referenced by specifications.

Each API family should be read as an independent contract unless it explicitly references another file or shared component.

## Integration Guidance

Before implementing against one of these APIs:

- Start from the API family that matches your integration role.
- Review the `info`, `servers`, `security`, `tags`, paths, schemas, examples, and protocol-specific notes.
- Treat server URLs as environment indicators. Local, staging, production, and placeholder hosts may appear in the same specification.
- Confirm the required authentication mechanism for the selected endpoints.
- Pay attention to WebSocket and MQTT notes, because those protocols may be documented with extensions or descriptive fields where a pure HTTP contract is not sufficient.
- Review examples as integration aids, not as exhaustive test vectors.
- Check whether the selected specification is suitable for code generation, especially for protocol-constrained or use-case-specific specifications.

## Contract Conventions

The specifications use a mix of JSON and YAML files and include both OpenAPI 3.0 and OpenAPI 3.1 documents. This reflects the source contracts currently maintained by each API family.

Common conventions:

- Paths describe the resource or operation exposed by the service.
- Schemas define request and response payload structures.
- Security sections define the authentication model expected by the API.
- Tags group operations by functional domain.
- Examples illustrate common payloads and expected formats.
- Vendor extensions may document WebSocket behavior, MQTT topics, tag grouping, or protocol-specific behavior not represented directly by standard HTTP fields.

## Reader Notes

These specifications are API contracts, not implementation source code. They should be used together with the target service, deployment environment, and integration agreements for a complete implementation.

When a specification contains a warning, limitation, or compliance note, treat it as part of the contract. This is especially important for OpenADR, WebSocket behavior, certificate flows, and generated client or server code.
