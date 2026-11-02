source(TopologyId, NodeId):-
  node(NodeId, TopologyId),
  edge(NodeId,_,  TopologyId),
  \+ edge(_, NodeId, TopologyId).
  

unique_source(TopologyId,NodeId):-
    findall(N, source(TopologyId,N), [NodeId]), length([NodeId], L), L ==1.
	
sink(TopologyId, NodeId):-
  node(NodeId, TopologyId),
  edge(_,NodeId,  TopologyId),
  \+ edge(NodeId, _, TopologyId).
  

unique_sink(TopologyId, NodeId):-
    findall(N, sink(TopologyId,N), [NodeId]), length([NodeId], L), L ==1.
	
