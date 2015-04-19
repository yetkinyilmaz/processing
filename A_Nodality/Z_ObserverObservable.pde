class ObservableObject {  
  ObservableObject() {
    m_observers = new ArrayList<ObserverObject>();
  }

  public void notifyObjectChanged(Object arg) {
    for (ObserverObject o : m_observers) {
      o.objectUpdated(this, arg);
    }
  }

  void plug(ObserverObject listener) {
    m_observers.add(listener);
  }

  private ArrayList<ObserverObject> m_observers;
}

interface ObserverObject {
  public void objectUpdated(ObservableObject obs, Object arg) ;
}
