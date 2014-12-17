require 'rails_helper'

RSpec.describe Colour::CalculateDistance do
  describe "finds the distance between two colors" do
    context "when supplied RGB colours" do
      it "calculates between a light blue and a dark blue" do
        c1 = { r: 20,  g: 40,  b: 60  }
        c2 = { r: 100, g: 200, b: 230 }
        expect(Colour::CalculateDistance.call(c1, c2)).to eq(64.27665355894416)
      end

      it "calculates between red and green" do
        c1 = { r: 255, g: 0,   b: 0   }
        c2 = { r: 0,   g: 255, b: 0   }
        expect(Colour::CalculateDistance.call(c1, c2)).to eq(170.5842008175292)
      end

      it "calculates between white and black" do
        c1 = { r: 255, g: 255, b: 255   }
        c2 = { r: 0,   g: 0,   b: 0     }
        expect(Colour::CalculateDistance.call(c1, c2)).to eq(100.00000068001583)
      end
    end

    context "when supplied an RGB and a LAB colour" do
      it "calculates between a purple and a brown" do
        c1 = { l: 50,  a: 10,  b: -30   }
        c2 = { r: 128, g: 51,  b: 0     }
        expect(Colour::CalculateDistance.call(c1, c2)).to eq(78.21455636686163)
      end

      it "calculates between two very similar reds" do
        c1 = { l: 51,  a: 73,  b: 55    }
        c2 = { r: 238, g: 28,  b: 32    }
        expect(Colour::CalculateDistance.call(c1, c2)).to eq(1.3901888027433325)
      end

    end
  end

end
