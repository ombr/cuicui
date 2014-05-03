# StyleHelper
module StyleHelper
  def background_position_to_absolute(background)
    hd, vd = background.split(' ')
    style = ''
    vs = return_other_selector('top bottom', vd)
    style += "#{vs}: auto;" if vs
    hs = return_other_selector('left right', hd)
    style += "#{hs}: auto;" if hs
    style
  end

  private

  def return_other_selector(list, selector)
    list = list.split(' ')
    list.delete(selector)
    return list.first if list.length == 1
    nil
  end
end
