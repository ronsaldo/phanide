automata simulation
simulationStateForActiveStates: activeStateSet
	self flag: 'Check the performance cost of the mutex.'.
	"simulationStateCacheMutex critical: ["
		^ simulationStateCache at: activeStateSet ifAbsentPut: [
			self createSimulationStateForActiveStates: activeStateSet
		]
	"]"