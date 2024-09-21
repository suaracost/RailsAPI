module Types
  class PersonaType < Types::BaseObject
    field :cedula, String, null: false
    field :nombre, String, null: false
  end
end
