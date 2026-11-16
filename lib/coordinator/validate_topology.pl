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
	

dfs(NodeIdIn, Vertices,TopologyId,NodeIdOut):-
    edge(NodeIdIn, NodeIdOut, TopologyId);
    edge(NodeIdIn, OtherId,TopologyId),
    \+ member(OtherId, Vertices),   
    dfs(OtherId, [OtherId | Vertices], TopologyId, NodeIdOut).

unique_id(NodeID, TopologyId):- \+ node(NodeID,TopologyId).


reachable_from_to(SourceId, SinkId, TopologyId, Id):-
    edge(SourceId, Id, TopologyId),
    node(Id, TopologyId),
    dfs(Id, [], TopologyId, SinkId).

reachable_from_to_all(SourceId, SinkId, TopologyId, Bag):-
     findall(Id, reachable_from_to(SourceId, SinkId, TopologyId, Id), Bag).
