require './workspace'

class JsonBuilder
  def chart_json(data)
    return_val = {}
    values = data.collect { |role, value| {'label' => role, 'values' => value} }
    return_val['label'] = ["Male", "Female"]
    return_val['values'] = values
    return_val.to_json
  end
end