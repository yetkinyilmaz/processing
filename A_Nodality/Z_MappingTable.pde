import java.util.Iterator;

public interface Process {
  public void execute(Pin in, Pin out);
}

class Mapping implements ObserverObject {
  public Mapping(Node dev, Property prop, String chName, Process process) {
    this.dev = dev;
    this.prop = prop;
    this.chName = chName;
    this.dev.plug(this);
    this.process = process;
  }

  public void objectUpdated(ObservableObject obs, Object arg) {
    String ch = (String) arg;
    if (ch.equals(this.chName)) {
      Node dev = (Node) obs;
      Pin v = dev.getOutputPin(ch);
      if (v!=null) {
        process.execute(dev.getOutputPin(ch), prop.value);
        prop.notifyObjectChanged(prop.name);
      } else {
        println("error the ouput " + ch + " does not exist" );
      }
    }
  }

  public boolean equals(Object object)
  {
    Mapping mapping = (Mapping) object;
    return (chName == mapping.chName && prop.name == mapping.prop.name);
  }

  private Node dev;
  private Property prop;
  private String chName;
  private Process process;
}

class MappingTable implements Iterable {
  public MappingTable() {
    mappingTable = new ArrayList<Mapping>();
  }

  void add(Node dev, Property prop, String chName, Process proc) { 
    Mapping m = new Mapping(dev, prop, chName, proc);
    if (!mappingTable.contains(m)) {
      mappingTable.add(m);
      println(chName+" plugged to " + prop.name);
    } else {
      println("error you have allready registered the mapping : " + chName +" - "+prop.name  );
    }
  }

  public Iterator<Mapping> iterator() {
    return mappingTable.iterator();
  }

  private ArrayList<Mapping> mappingTable;
}
