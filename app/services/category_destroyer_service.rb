class CategoryDestroyerService
  attr_accessor :category

  def initialize(category, params)
    @category = category
    @params = params
  end

  def destroy
    case @params[:type]
    when 'full'
      full_destroy
    when 'hide'
      hide_category
    when 'change'
      #   before_destroy :check_category_type
      set_to_new_category
    else
      @category.errors[:base] << 'Check available types of destroying'
    end
  end

  private

  def hide_category
    @category.hidden!
    {}
  end

  def full_destroy; end

  def set_to_new_category; end
end
