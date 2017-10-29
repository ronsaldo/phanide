communication
wait: aSemaphoreMutexToRelease
	"Release the mutex"
	| activeProcess waitFinished |
	mutex wait.
	aSemaphoreMutexToRelease signal.
	activeProcess := Processor activeProcess.
	waitingQueue add: activeProcess.
	
	"Release the mutex and suspend the active process, atomically."
	waitFinished := Semaphore new.
	[
		activeProcess suspend.
		mutex signal.
		waitFinished signal.
	] forkAt: Processor highestPriority.
	waitFinished wait.
	
	"Reacquire the mutex"
	aSemaphoreMutexToRelease wait