module ApplicationHelper
  
  def get_random_welcome()
    welcome = ["Neguses till the end",
              "Once a Negus, always a Negus",
              "Word is Bond, Word is Strong",
              "BRRRRR",
              "Slay the deadly goats",
              "Sometimes you just gotta feed the sheep"]


    "#{welcome[rand(6)]}"        
    
  end
end
