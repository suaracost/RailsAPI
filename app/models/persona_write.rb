class PersonaWrite
    attr_accessor :cedula, :nombre
  
    def initialize(cedula, nombre)
      @cedula = cedula
      @nombre = nombre
    end
  
    def save
      $cassandra_session.execute(
        "INSERT INTO persona_write (cedula, nombre) VALUES (?, ?)",
        arguments: [@cedula, @nombre]
      )
    end
  end
  