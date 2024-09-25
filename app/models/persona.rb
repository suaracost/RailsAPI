class Persona
    attr_accessor :cedula, :nombre
  
    def initialize(cedula, nombre)
      @cedula = cedula
      @nombre = nombre
    end
  
    # Método para insertar un nuevo registro en Cassandra
    def save
      $cassandra_session.execute(
        "INSERT INTO persona (cedula, nombre) VALUES (?, ?)",
        arguments: [@cedula, @nombre]
      )
    end
  
    # Método para obtener todas las personas de Cassandra
    def self.all
      rows = $cassandra_session.execute("SELECT * FROM persona")
      rows.map { |row| new(row['cedula'], row['nombre']) }
    end
  end
  