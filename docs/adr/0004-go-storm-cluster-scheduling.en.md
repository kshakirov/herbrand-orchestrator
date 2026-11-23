# ADR-004: Declarative Scheduling and Distributed Cluster Management for GO STORM

**Status:** Proposed  
**Project:** Herbrand Orchestrator / GO STORM  
**Scope:** Prolog, Elixir/BEAM, Go

## 1. Context

GO STORM is a distributed stream-processing system based on three specialized components:

- **Prolog** — declarative representation and logical inference.
- **Elixir/BEAM** — distributed coordination and execution management.
- **Go** — execution of user-defined stream-processing workloads.

The user defines the logical computation graph. Prolog maintains its representation, provides topology maps, and derives execution-planning decisions.

An Elixir/BEAM node runs on every physical host. No additional dedicated deployment agent is required.

## 2. Decision

Develop Herbrand Orchestrator as a declarative scheduler for the distributed cluster.

Prolog is responsible for:

1. Representing user-defined topologies, isolated by `TopologyID`.
2. Representing physical hosts, available resources, and constraints.
3. Deriving valid placements of logical nodes.
4. Evaluating aggregated load statistics.
5. Deriving load-balancing and parallelism adjustments.
6. Selecting alternative placements after failures.
7. Producing topology maps and reconfiguration commands for Elixir.

Prolog does not manage TCP connections, process user DATA frames, or directly launch Go processes.

## 3. Distributed Control Layer

Elixir/BEAM runs on every physical host.

Its responsibilities include:

- communication between BEAM nodes;
- starting and stopping local Go processes;
- monitoring processes and host availability;
- collecting and aggregating metrics;
- applying Prolog decisions;
- maintaining stream-routing infrastructure.

Erlang Ports or another local process-management mechanism may be used to launch Go executables.

Loss of connectivity must not automatically be treated as definitive proof of physical host failure.

## 4. Logical and Physical Models

The **logical model** is user-defined and contains:

- topologies;
- logical nodes;
- directed edges;
- node roles.

The **physical model** contains:

- hosts;
- CPU and memory resources;
- process placement;
- availability information;
- observed load.

Prolog connects these models through a placement relation:

```prolog
placement(TopologyID, NodeID, HostID).
```

This is a conceptual predicate. Its concrete representation will be determined during implementation.

Changing physical placement must not arbitrarily modify the user-defined logical graph.

## 5. Scheduling and Load Balancing

The scheduler receives the current configuration, constraints, and observed cluster state.

It derives an admissible target configuration.

Future scheduling policies may consider:

- CPU and memory;
- queue utilization;
- throughput;
- placement affinity and anti-affinity;
- topology isolation;
- migration cost;
- parallelism requirements.

Constraint logic programming, including `CLP(FD)`, is a research direction for implementing these policies.

Local backpressure control remains within Go and Elixir. Prolog is involved when a cluster-level configuration change is required.

## 6. Failure Handling and Reconfiguration

The proposed control cycle is:

1. Elixir detects a change in cluster state.
2. Updated observations are provided to Prolog.
3. Prolog derives a new valid placement or reconfiguration plan.
4. Elixir coordinates execution of the plan across relevant hosts.
5. Go processes resume or continue stream processing after the new configuration becomes active.

The implementation must separately define change ordering, protection against conflicting plans, and behavior under network partitions.

## 7. Architectural Boundaries

- Users define logical graphs; Prolog does not arbitrarily generate them.
- Prolog stays outside the user-data hot path.
- BEAM provides the distributed control layer on every host.
- Go remains the computation engine.
- The system targets pure stream processing without the Trident transactional model.
- Delivery guarantees and ChainDB-based buffering are separate design topics.

## 8. Preliminary Implementation Phases

1. Physical resource and placement model.
2. Distributed Go process deployment through BEAM.
3. Metrics collection and cluster-state representation.
4. Declarative load-balancing rules.
5. Failure recovery and replacement placement.
6. Reconfiguration and overload management.

## 9. Expected Outcome

Herbrand Orchestrator becomes a logical scheduler that determines admissible and preferred configurations of a distributed cluster.

Elixir/BEAM coordinates transitions to those configurations and handles operational management.

Go executes user-defined streaming computations.

**Architectural principle: Prolog decides, Elixir coordinates execution, Go processes the stream.**
