import time
import random
from enum import Enum

# Define states of the Circuit Breaker
class State(Enum):
    CLOSED = "CLOSED"       # Normal operation (all requests allowed)
    OPEN = "OPEN"           # Requests blocked (service considered down)
    HALF_OPEN = "HALF_OPEN" # Trial mode (few requests allowed after timeout)

class CircuitBreaker:
    def __init__(self, failure_threshold=3, recovery_timeout=5, half_open_attempts=1):
        """
        :param failure_threshold: Number of consecutive failures allowed before switching to OPEN
        :param recovery_timeout: Time in seconds to wait before moving from OPEN -> HALF_OPEN
        :param half_open_attempts: Number of trial requests allowed in HALF_OPEN state
        """
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.half_open_attempts = half_open_attempts

        # Initial state is CLOSED (everything works normally)
        self.state = State.CLOSED
        self.failure_count = 0
        self.last_failure_time = None

    def call(self, func, *args, **kwargs):
        """
        Wraps a function call with Circuit Breaker logic.
        Blocks calls if the circuit is OPEN.
        """
        # If circuit is OPEN, check if timeout has passed to switch to HALF_OPEN
        if self.state == State.OPEN:
            if (time.time() - self.last_failure_time) > self.recovery_timeout:
                self.state = State.HALF_OPEN
            else:
                # Block request immediately (fail fast)
                raise Exception("CircuitBreaker: OPEN state - request blocked")

        try:
            # Attempt to call the wrapped function
            result = func(*args, **kwargs)
        except Exception as e:
            # On failure, update breaker state
            self._on_failure()
            raise e
        else:
            # On success, reset breaker state
            self._on_success()
            return result

    def _on_success(self):
        """
        Reset failure count and close the circuit if it was HALF_OPEN.
        """
        self.failure_count = 0
        if self.state in [State.HALF_OPEN, State.CLOSED]:
            self.state = State.CLOSED

    def _on_failure(self):
        """
        Increment failure count and OPEN the circuit if threshold exceeded.
        """
        self.failure_count += 1
        self.last_failure_time = time.time()

        # If already HALF_OPEN or failures exceed threshold -> OPEN
        if self.state == State.HALF_OPEN or self.failure_count >= self.failure_threshold:
            self.state = State.OPEN

# --- Example Usage (Simulation) ---

def unreliable_service():
    """
    Fake service that randomly fails with 30% probability.
    Represents Service B in a microservices setup.
    """
    if random.random() < 0.3:  # 30% chance of failure
        raise Exception("Service B failed!")
    return "Response from Service B"

if __name__ == "__main__":
    # Initialize CircuitBreaker with:
    # - 2 failures allowed
    # - 5 sec recovery timeout
    cb = CircuitBreaker(failure_threshold=2, recovery_timeout=5)

    # Simulate 10 calls to unreliable service
    for i in range(10):
        try:
            response = cb.call(unreliable_service)
            print(f"Call {i+1}: SUCCESS -> {response} | State: {cb.state.value}")
        except Exception as e:
            print(f"Call {i+1}: FAILURE -> {e} | State: {cb.state.value}")

        # Add 1 second delay to mimic real calls
        time.sleep(1)
