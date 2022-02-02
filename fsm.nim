import tables, options

type
  Callback*[S,R] = proc(_:S): R
  StateEvent*[S,E] = tuple[state: S, event: E]
  Transition*[S,R] = tuple[nexState: S, action: Callback[S,R]]

  Machine*[S,E,R] =  object
    state*: S
    transitions*: Table[StateEvent[S,E], Transition[S,R]]

proc addTransition*[S,E,R](m: var Machine[S,E,R], state: S, event: E, nextState: S, action: Callback[S,R]) =
  m.transitions[(state, event)] = (nextState, action)

proc getTransition*[S,E,R](m: var Machine[S,E,R], event: E, state: S): Option[Transition[S,R]] =
  let map = (state, event)
  if m.transitions.hasKey(map):
    some(m.transitions[map])
  else:
    none(Transition[S,R])

proc processEvent*[S,E,R](m: var Machine[S,E,R], event: E): Option[R] =
  let transition = m.getTransition(event, m.state)
  if transition.isSome:
    let transition = transition.get
    let prevState = m.state
    m.state = transition[0]
    some(transition[1](prevState))
  else:
    none(R)
