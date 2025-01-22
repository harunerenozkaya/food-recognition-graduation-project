struct NutritionInformation {
    let classId : Int
    let classLabel : String
    let gram : Double
    let calorie : Double
    let carb : Double
    let protein : Double
    let fat : Double
    
    init(_ classId: Int, _ classLabel: String, _ gram: Double, _ calorie: Double, _ carb: Double, _ protein: Double, _ fat: Double) {
        self.classId = classId
        self.classLabel = classLabel
        self.gram = gram
        self.calorie = calorie
        self.carb = carb
        self.protein = protein
        self.fat = fat
    }
}

struct NutiritionInformationBasic {
    let calorie: Double 
    let carb: Double     
    let protein: Double  
    let fat: Double      
}

class NutritionData {
    static let nutritionInfoFor100Gr: [Int: NutiritionInformationBasic] = [
        // 0: "Japanese tofu and vegetable chowder"
        0:  NutiritionInformationBasic(calorie: 40, carb: 3, protein: 3, fat: 1),

        // 1: "Japanese-style pancake (Okonomiyaki)"
        1:  NutiritionInformationBasic(calorie: 220, carb: 28, protein: 8, fat: 9),

        // 2: "beef bowl (Gyudon)"
        2:  NutiritionInformationBasic(calorie: 150, carb: 15, protein: 8, fat: 7),

        // 3: "beef curry"
        3:  NutiritionInformationBasic(calorie: 180, carb: 18, protein: 10, fat: 8),

        // 4: "beef noodle"
        4:  NutiritionInformationBasic(calorie: 120, carb: 15, protein: 7, fat: 3),

        // 5: "beef steak"
        5:  NutiritionInformationBasic(calorie: 250, carb: 0, protein: 26, fat: 16),

        // 6: "bibimbap"
        6:  NutiritionInformationBasic(calorie: 200, carb: 30, protein: 7, fat: 5),

        // 7: "boiled chicken and vegetables"
        7:  NutiritionInformationBasic(calorie: 120, carb: 3, protein: 15, fat: 4),

        // 8: "boiled fish"
        8:  NutiritionInformationBasic(calorie: 120, carb: 0, protein: 20, fat: 4),

        // 9: "cabbage roll"
        9:  NutiritionInformationBasic(calorie: 110, carb: 7, protein: 6, fat: 6),

        // 10: "chicken rice"
        10: NutiritionInformationBasic(calorie: 180, carb: 25, protein: 8, fat: 4),

        // 11: "chicken-n-egg on rice (Oyakodon)"
        11: NutiritionInformationBasic(calorie: 160, carb: 20, protein: 10, fat: 4),

        // 12: "chilled noodle"
        12: NutiritionInformationBasic(calorie: 120, carb: 20, protein: 4, fat: 2),

        // 13: "chinese soup"
        13: NutiritionInformationBasic(calorie: 50,  carb: 6,  protein: 3,  fat: 1),

        // 14: "chip butty"
        14: NutiritionInformationBasic(calorie: 250, carb: 36, protein: 5,  fat: 8),

        // 15: "cold tofu"
        15: NutiritionInformationBasic(calorie: 70,  carb: 2,  protein: 8,  fat: 4),

        // 16: "croissant"
        16: NutiritionInformationBasic(calorie: 406, carb: 45, protein: 8,  fat: 21),

        // 17: "croquette"
        17: NutiritionInformationBasic(calorie: 170, carb: 20, protein: 6,  fat: 8),

        // 18: "cutlet curry"
        18: NutiritionInformationBasic(calorie: 220, carb: 24, protein: 10, fat: 9),

        // 19: "dipping noodles (Tsukemen)"
        19: NutiritionInformationBasic(calorie: 170, carb: 25, protein: 8,  fat: 3),

        // 20: "dried fish"
        20: NutiritionInformationBasic(calorie: 150, carb: 0,  protein: 25, fat: 4),

        // 21: "eels on rice (Unadon)"
        21: NutiritionInformationBasic(calorie: 290, carb: 30, protein: 14, fat: 12),

        // 22: "egg roll"
        22: NutiritionInformationBasic(calorie: 150, carb: 8,  protein: 9,  fat: 8),

        // 23: "egg sunny-side up"
        23: NutiritionInformationBasic(calorie: 180, carb: 1,  protein: 12, fat: 14),

        // 24: "fermented soybeans (Natto)"
        24: NutiritionInformationBasic(calorie: 200, carb: 12, protein: 18, fat: 9),

        // 25: "fish-shaped pancake w/ bean jam (Taiyaki)"
        25: NutiritionInformationBasic(calorie: 240, carb: 45, protein: 7,  fat: 3),

        // 26: "french fries"
        26: NutiritionInformationBasic(calorie: 312, carb: 41, protein: 3,  fat: 15),

        // 27: "fried chicken (Karaage)"
        27: NutiritionInformationBasic(calorie: 250, carb: 8,  protein: 18, fat: 16),

        // 28: "fried fish"
        28: NutiritionInformationBasic(calorie: 240, carb: 12, protein: 15, fat: 15),

        // 29: "fried noodle (Yakisoba)"
        29: NutiritionInformationBasic(calorie: 200, carb: 30, protein: 7,  fat: 6),

        // 30: "fried rice (Chahan)"
        30: NutiritionInformationBasic(calorie: 180, carb: 25, protein: 6,  fat: 5),

        // 31: "fried shrimp (Ebi fry)"
        31: NutiritionInformationBasic(calorie: 220, carb: 15, protein: 16, fat: 10),

        // 32: "ganmodoki (tofu fritter)"
        32: NutiritionInformationBasic(calorie: 170, carb: 8,  protein: 9,  fat: 12),

        // 33: "ginger pork saute (Shogayaki)"
        33: NutiritionInformationBasic(calorie: 210, carb: 6,  protein: 16, fat: 14),

        // 34: "goya chanpuru"
        34: NutiritionInformationBasic(calorie: 140, carb: 10, protein: 10, fat: 7),

        // 35: "gratin"
        35: NutiritionInformationBasic(calorie: 180, carb: 15, protein: 9,  fat: 10),

        // 36: "green salad"
        36: NutiritionInformationBasic(calorie: 20,  carb: 3,  protein: 1,  fat: 0),

        // 37: "grilled eggplant"
        37: NutiritionInformationBasic(calorie: 80,  carb: 6,  protein: 2,  fat: 5),

        // 38: "grilled pacific saury (Sanma)"
        38: NutiritionInformationBasic(calorie: 210, carb: 0,  protein: 22, fat: 13),

        // 39: "grilled salmon"
        39: NutiritionInformationBasic(calorie: 200, carb: 0,  protein: 25, fat: 12),

        // 40: "hambarg steak (Hambagu)"
        40: NutiritionInformationBasic(calorie: 230, carb: 7,  protein: 15, fat: 15),

        // 41: "hamburger"
        41: NutiritionInformationBasic(calorie: 250, carb: 31, protein: 13, fat: 8),

        // 42: "hot dog"
        42: NutiritionInformationBasic(calorie: 290, carb: 30, protein: 11, fat: 14),

        // 43: "jiaozi (Gyoza)"
        43: NutiritionInformationBasic(calorie: 180, carb: 20, protein: 8,  fat: 7),

        // 44: "kinpira-style sauteed burdock"
        44: NutiritionInformationBasic(calorie: 140, carb: 20, protein: 3,  fat: 5),

        // 45: "lightly roasted fish (Aburi)"
        45: NutiritionInformationBasic(calorie: 120, carb: 1,  protein: 22, fat: 3),

        // 46: "macaroni salad"
        46: NutiritionInformationBasic(calorie: 220, carb: 28, protein: 5,  fat: 9),

        // 47: "miso soup"
        47: NutiritionInformationBasic(calorie: 40,  carb: 4,  protein: 3,  fat: 1),

        // 48: "mixed rice (Takikomi gohan)"
        48: NutiritionInformationBasic(calorie: 165, carb: 30, protein: 5,  fat: 2),

        // 49: "nanbanzuke (marinated fried fish w/ vinegar sauce)"
        49: NutiritionInformationBasic(calorie: 150, carb: 9,  protein: 12, fat: 7),

        // 50: "oden"
        50: NutiritionInformationBasic(calorie: 80,  carb: 10, protein: 6,  fat: 2),

        // 51: "omelet"
        51: NutiritionInformationBasic(calorie: 150, carb: 2,  protein: 10, fat: 11),

        // 52: "omelet with fried rice (Omurice)"
        52: NutiritionInformationBasic(calorie: 180, carb: 22, protein: 8,  fat: 7),

        // 53: "pilaf"
        53: NutiritionInformationBasic(calorie: 180, carb: 28, protein: 4,  fat: 4),

        // 54: "pizza"
        54: NutiritionInformationBasic(calorie: 270, carb: 33, protein: 11, fat: 10),

        // 55: "pizza toast"
        55: NutiritionInformationBasic(calorie: 300, carb: 35, protein: 12, fat: 12),

        // 56: "pork cutlet on rice (Katsudon)"
        56: NutiritionInformationBasic(calorie: 250, carb: 30, protein: 11, fat: 10),

        // 57: "pork miso soup (Tonjiru)"
        57: NutiritionInformationBasic(calorie: 120, carb: 10, protein: 7,  fat: 6),

        // 58: "potage" (thick soup)
        58: NutiritionInformationBasic(calorie: 80,  carb: 10, protein: 3,  fat: 3),

        // 59: "potato salad"
        59: NutiritionInformationBasic(calorie: 140, carb: 18, protein: 3,  fat: 6),

        // 60: "raisin bread"
        60: NutiritionInformationBasic(calorie: 290, carb: 57, protein: 7,  fat: 4),

        // 61: "ramen noodle" (broth + noodles)
        61: NutiritionInformationBasic(calorie: 150, carb: 22, protein: 6,  fat: 3),

        // 62: "rice (cooked)"
        62: NutiritionInformationBasic(calorie: 130, carb: 28, protein: 2,  fat: 0),

        // 63: "rice ball (Onigiri)"
        63: NutiritionInformationBasic(calorie: 180, carb: 39, protein: 3,  fat: 2),

        // 64: "roast chicken"
        64: NutiritionInformationBasic(calorie: 200, carb: 0,  protein: 30, fat: 8),

        // 65: "roll bread"
        65: NutiritionInformationBasic(calorie: 280, carb: 50, protein: 9,  fat: 5),

        // 66: "rolled omelet (Tamagoyaki)"
        66: NutiritionInformationBasic(calorie: 150, carb: 5,  protein: 9,  fat: 10),

        // 67: "salmon meuniere"
        67: NutiritionInformationBasic(calorie: 220, carb: 3,  protein: 24, fat: 12),

        // 68: "sandwiches"
        68: NutiritionInformationBasic(calorie: 250, carb: 30, protein: 12, fat: 10),

        // 69: "sashimi"
        69: NutiritionInformationBasic(calorie: 120, carb: 0,  protein: 23, fat: 3),

        // 70: "sashimi bowl (Kaisendon)"
        70: NutiritionInformationBasic(calorie: 160, carb: 20, protein: 14, fat: 3),

        // 71: "sausage"
        71: NutiritionInformationBasic(calorie: 300, carb: 1,  protein: 14, fat: 28),

        // 72: "sauteed spinach"
        72: NutiritionInformationBasic(calorie: 70,  carb: 3,  protein: 4,  fat: 5),

        // 73: "sauteed vegetables"
        73: NutiritionInformationBasic(calorie: 80,  carb: 10, protein: 3,  fat: 4),

        // 74: "seasoned beef with potatoes (Nikujaga)"
        74: NutiritionInformationBasic(calorie: 140, carb: 18, protein: 7,  fat: 5),

        // 75: "shrimp with chili sauce"
        75: NutiritionInformationBasic(calorie: 180, carb: 15, protein: 12, fat: 8),

        // 76: "simmered pork (Kakuni)"
        76: NutiritionInformationBasic(calorie: 280, carb: 5,  protein: 18, fat: 21),

        // 77: "sirloin cutlet"
        77: NutiritionInformationBasic(calorie: 320, carb: 10, protein: 21, fat: 23),

        // 78: "soba noodle"
        78: NutiritionInformationBasic(calorie: 130, carb: 24, protein: 5,  fat: 1),

        // 79: "spaghetti"
        79: NutiritionInformationBasic(calorie: 158, carb: 31, protein: 6,  fat: 1),

        // 80: "spaghetti meat sauce"
        80: NutiritionInformationBasic(calorie: 180, carb: 25, protein: 8,  fat: 5),

        // 81: "spicy chili-flavored tofu (Mapo tofu)"
        81: NutiritionInformationBasic(calorie: 150, carb: 9,  protein: 10, fat: 8),

        // 82: "steamed egg hotchpotch (Chawanmushi)"
        82: NutiritionInformationBasic(calorie: 80,  carb: 4,  protein: 7,  fat: 4),

        // 83: "steamed meat dumpling (Shumai)"
        83: NutiritionInformationBasic(calorie: 180, carb: 15, protein: 9,  fat: 8),

        // 84: "stew"
        84: NutiritionInformationBasic(calorie: 100, carb: 10, protein: 6,  fat: 4),

        // 85: "stir-fried beef and peppers"
        85: NutiritionInformationBasic(calorie: 200, carb: 6,  protein: 14, fat: 14),

        // 86: "sukiyaki"
        86: NutiritionInformationBasic(calorie: 210, carb: 10, protein: 18, fat: 11),

        // 87: "sushi"
        87: NutiritionInformationBasic(calorie: 130, carb: 28, protein: 3,  fat: 0),

        // 88: "sushi bowl (Barachirashi)"
        88: NutiritionInformationBasic(calorie: 140, carb: 25, protein: 5,  fat: 3),

        // 89: "sweet and sour pork"
        89: NutiritionInformationBasic(calorie: 180, carb: 15, protein: 12, fat: 8),

        // 90: "takoyaki"
        90: NutiritionInformationBasic(calorie: 200, carb: 26, protein: 8,  fat: 7),

        // 91: "tempura"
        91: NutiritionInformationBasic(calorie: 290, carb: 20, protein: 8,  fat: 20),

        // 92: "tempura bowl (Tendon)"
        92: NutiritionInformationBasic(calorie: 290, carb: 40, protein: 8,  fat: 12),

        // 93: "tempura udon"
        93: NutiritionInformationBasic(calorie: 120, carb: 18, protein: 6,  fat: 2),

        // 94: "tensin noodle" (shrimp tempura on noodle)
        94: NutiritionInformationBasic(calorie: 130, carb: 20, protein: 7,  fat: 3),

        // 95: "teriyaki grilled fish"
        95: NutiritionInformationBasic(calorie: 180, carb: 4,  protein: 20, fat: 10),

        // 96: "toast"
        96: NutiritionInformationBasic(calorie: 253, carb: 47.69, protein: 7.36,  fat: 3.34),

        // 97: "udon noodle"
        97: NutiritionInformationBasic(calorie: 130, carb: 25, protein: 4,  fat: 1),

        // 98: "vegetable tempura"
        98: NutiritionInformationBasic(calorie: 250, carb: 30, protein: 5,  fat: 12),

        // 99: "yakitori"
        99: NutiritionInformationBasic(calorie: 180, carb: 3,  protein: 20, fat: 11)
    ]
    
    /// Approximate "one-portion" sizes for each dish (in grams).
    static let portionSizeInGrams: [Int: Double] = [
        0: 250,  // Japanese tofu and vegetable chowder
        1: 200,  // Japanese-style pancake (Okonomiyaki)
        2: 250,  // beef bowl (Gyudon)
        3: 250,  // beef curry
        4: 300,  // beef noodle
        5: 200,  // beef steak
        6: 300,  // bibimbap
        7: 200,  // boiled chicken and vegetables
        8: 150,  // boiled fish
        9: 150,  // cabbage roll
        10: 250, // chicken rice
        11: 250, // chicken-n-egg on rice (Oyakodon)
        12: 300, // chilled noodle
        13: 200, // chinese soup
        14: 200, // chip butty
        15: 100, // cold tofu
        16: 60,  // croissant
        17: 80,  // croquette
        18: 300, // cutlet curry
        19: 300, // dipping noodles (Tsukemen)
        20: 80,  // dried fish
        21: 300, // eels on rice (Unadon)
        22: 100, // egg roll
        23: 55,  // egg sunny-side up
        24: 50,  // fermented soybeans (Natto)
        25: 100, // fish-shaped pancake (Taiyaki)
        26: 100, // french fries
        27: 100, // fried chicken (Karaage)
        28: 120, // fried fish
        29: 250, // fried noodle (Yakisoba)
        30: 200, // fried rice (Chahan)
        31: 120, // fried shrimp (Ebi fry)
        32: 80,  // ganmodoki (tofu fritter)
        33: 150, // ginger pork saute (Shogayaki)
        34: 250, // goya chanpuru
        35: 200, // gratin
        36: 120, // green salad
        37: 100, // grilled eggplant
        38: 120, // grilled pacific saury (Sanma)
        39: 100, // grilled salmon
        40: 150, // hambarg steak (Hambagu)
        41: 150, // hamburger
        42: 150, // hot dog
        43: 120, // jiaozi (Gyoza)
        44: 120, // kinpira-style sauteed burdock
        45: 120, // lightly roasted fish (Aburi)
        46: 150, // macaroni salad
        47: 200, // miso soup
        48: 200, // mixed rice (Takikomi gohan)
        49: 100, // nanbanzuke
        50: 300, // oden
        51: 80,  // omelet
        52: 300, // omelet w/ fried rice (Omurice)
        53: 250, // pilaf
        54: 350, // pizza
        55: 100, // pizza toast
        56: 250, // pork cutlet on rice (Katsudon)
        57: 200, // pork miso soup (Tonjiru)
        58: 150, // potage
        59: 100, // potato salad
        60: 80,  // raisin bread
        61: 400, // ramen noodle
        62: 150, // rice (cooked)
        63: 120, // rice ball (Onigiri)
        64: 150, // roast chicken
        65: 80,  // roll bread
        66: 100, // rolled omelet (Tamagoyaki)
        67: 120, // salmon meuniere
        68: 130, // sandwiches
        69: 120, // sashimi
        70: 250, // sashimi bowl (Kaisendon)
        71: 50,  // sausage
        72: 80,  // sauteed spinach
        73: 100, // sauteed vegetables
        74: 200, // seasoned beef w/ potatoes (Nikujaga)
        75: 120, // shrimp with chili sauce
        76: 100, // simmered pork (Kakuni)
        77: 150, // sirloin cutlet
        78: 400, // soba noodle
        79: 200, // spaghetti
        80: 300, // spaghetti meat sauce
        81: 200, // spicy chili-flavored tofu (Mapo tofu)
        82: 80,  // steamed egg hotchpotch (Chawanmushi)
        83: 100, // steamed meat dumpling (Shumai)
        84: 250, // stew
        85: 150, // stir-fried beef & peppers
        86: 250, // sukiyaki
        87: 200, // sushi
        88: 300, // sushi bowl (Barachirashi)
        89: 200, // sweet and sour pork
        90: 120, // takoyaki
        91: 80,  // tempura
        92: 300, // tempura bowl (Tendon)
        93: 350, // tempura udon
        94: 350, // tensin noodle
        95: 120, // teriyaki grilled fish
        96: 30,  // toast
        97: 300, // udon noodle
        98: 200, // vegetable tempura
        99: 120  // yakitori
    ]
    
    static let nutritionInfoForOnePorsion: [Int: NutiritionInformationBasic] = [

        0:  NutiritionInformationBasic(calorie: 100, carb: 8,  protein: 8,  fat: 3),
        1:  NutiritionInformationBasic(calorie: 440, carb: 56, protein: 16, fat: 18),
        2:  NutiritionInformationBasic(calorie: 375, carb: 38, protein: 20, fat: 18),
        3:  NutiritionInformationBasic(calorie: 450, carb: 45, protein: 25, fat: 20),
        4:  NutiritionInformationBasic(calorie: 360, carb: 45, protein: 21, fat: 9),
        5:  NutiritionInformationBasic(calorie: 500, carb: 0,  protein: 52, fat: 32),
        6:  NutiritionInformationBasic(calorie: 600, carb: 90, protein: 21, fat: 15),
        7:  NutiritionInformationBasic(calorie: 240, carb: 6,  protein: 30, fat: 8),
        8:  NutiritionInformationBasic(calorie: 180, carb: 0,  protein: 30, fat: 6),
        9:  NutiritionInformationBasic(calorie: 165, carb: 11, protein: 9,  fat: 9),
        10: NutiritionInformationBasic(calorie: 450, carb: 63, protein: 20, fat: 10),
        11: NutiritionInformationBasic(calorie: 400, carb: 50, protein: 25, fat: 10),
        12: NutiritionInformationBasic(calorie: 360, carb: 60, protein: 12, fat: 6),
        13: NutiritionInformationBasic(calorie: 100, carb: 12, protein: 6,  fat: 2),
        14: NutiritionInformationBasic(calorie: 500, carb: 72, protein: 10, fat: 16),
        15: NutiritionInformationBasic(calorie: 70,  carb: 2,  protein: 8,  fat: 4),
        16: NutiritionInformationBasic(calorie: 244, carb: 27, protein: 5,  fat: 13),
        17: NutiritionInformationBasic(calorie: 136, carb: 16, protein: 5,  fat: 6),
        18: NutiritionInformationBasic(calorie: 660, carb: 72, protein: 30, fat: 27),
        19: NutiritionInformationBasic(calorie: 510, carb: 75, protein: 24, fat: 9),
        20: NutiritionInformationBasic(calorie: 120, carb: 0,  protein: 20, fat: 3),
        21: NutiritionInformationBasic(calorie: 870, carb: 90, protein: 42, fat: 36),
        22: NutiritionInformationBasic(calorie: 150, carb: 8,  protein: 9,  fat: 8),
        23: NutiritionInformationBasic(calorie: 99,  carb: 1,  protein: 7,  fat: 8),
        24: NutiritionInformationBasic(calorie: 100, carb: 6,  protein: 9,  fat: 4),
        25: NutiritionInformationBasic(calorie: 240, carb: 45, protein: 7,  fat: 3),
        26: NutiritionInformationBasic(calorie: 312, carb: 41, protein: 3,  fat: 15),
        27: NutiritionInformationBasic(calorie: 250, carb: 8,  protein: 18, fat: 16),
        28: NutiritionInformationBasic(calorie: 288, carb: 14, protein: 18, fat: 18),
        29: NutiritionInformationBasic(calorie: 500, carb: 75, protein: 18, fat: 15),
        30: NutiritionInformationBasic(calorie: 360, carb: 50, protein: 12, fat: 10),
        31: NutiritionInformationBasic(calorie: 264, carb: 18, protein: 19, fat: 12),
        32: NutiritionInformationBasic(calorie: 136, carb: 6,  protein: 7,  fat: 10),
        33: NutiritionInformationBasic(calorie: 315, carb: 9,  protein: 24, fat: 21),
        34: NutiritionInformationBasic(calorie: 350, carb: 25, protein: 25, fat: 18),
        35: NutiritionInformationBasic(calorie: 360, carb: 30, protein: 18, fat: 20),
        36: NutiritionInformationBasic(calorie: 24,  carb: 4,  protein: 1,  fat: 0),
        37: NutiritionInformationBasic(calorie: 80,  carb: 6,  protein: 2,  fat: 5),
        38: NutiritionInformationBasic(calorie: 252, carb: 0,  protein: 26, fat: 16),
        39: NutiritionInformationBasic(calorie: 200, carb: 0,  protein: 25, fat: 12),
        40: NutiritionInformationBasic(calorie: 345, carb: 10, protein: 23, fat: 23),
        41: NutiritionInformationBasic(calorie: 375, carb: 47, protein: 20, fat: 12),
        42: NutiritionInformationBasic(calorie: 435, carb: 45, protein: 16, fat: 21),
        43: NutiritionInformationBasic(calorie: 216, carb: 24, protein: 10, fat: 8),
        44: NutiritionInformationBasic(calorie: 168, carb: 24, protein: 4,  fat: 6),
        45: NutiritionInformationBasic(calorie: 144, carb: 1,  protein: 26, fat: 4),
        46: NutiritionInformationBasic(calorie: 330, carb: 42, protein: 8,  fat: 14),
        47: NutiritionInformationBasic(calorie: 80,  carb: 8,  protein: 6,  fat: 2),
        48: NutiritionInformationBasic(calorie: 330, carb: 60, protein: 10, fat: 4),
        49: NutiritionInformationBasic(calorie: 150, carb: 9,  protein: 12, fat: 7),
        50: NutiritionInformationBasic(calorie: 240, carb: 30, protein: 18, fat: 6),
        51: NutiritionInformationBasic(calorie: 120, carb: 2,  protein: 8,  fat: 9),
        52: NutiritionInformationBasic(calorie: 540, carb: 66, protein: 24, fat: 21),
        53: NutiritionInformationBasic(calorie: 450, carb: 70, protein: 10, fat: 10),
        54: NutiritionInformationBasic(calorie: 405, carb: 50, protein: 16, fat: 15),
        55: NutiritionInformationBasic(calorie: 300, carb: 35, protein: 12, fat: 12),
        56: NutiritionInformationBasic(calorie: 625, carb: 75, protein: 28, fat: 25),
        57: NutiritionInformationBasic(calorie: 240, carb: 20, protein: 14, fat: 12),
        58: NutiritionInformationBasic(calorie: 120, carb: 15, protein: 5,  fat: 5),
        59: NutiritionInformationBasic(calorie: 140, carb: 18, protein: 3,  fat: 6),
        60: NutiritionInformationBasic(calorie: 232, carb: 46, protein: 6,  fat: 3),
        61: NutiritionInformationBasic(calorie: 600, carb: 88, protein: 24, fat: 12),
        62: NutiritionInformationBasic(calorie: 195, carb: 42, protein: 3,  fat: 0),
        63: NutiritionInformationBasic(calorie: 216, carb: 47, protein: 4,  fat: 2),
        64: NutiritionInformationBasic(calorie: 300, carb: 0,  protein: 45, fat: 12),
        65: NutiritionInformationBasic(calorie: 224, carb: 40, protein: 7,  fat: 4),
        66: NutiritionInformationBasic(calorie: 150, carb: 5,  protein: 9,  fat: 10),
        67: NutiritionInformationBasic(calorie: 264, carb: 4,  protein: 29, fat: 14),
        68: NutiritionInformationBasic(calorie: 325, carb: 39, protein: 16, fat: 13),
        69: NutiritionInformationBasic(calorie: 144, carb: 0,  protein: 28, fat: 4),
        70: NutiritionInformationBasic(calorie: 400, carb: 50, protein: 35, fat: 8),
        71: NutiritionInformationBasic(calorie: 150, carb: 1,  protein: 7,  fat: 14),
        72: NutiritionInformationBasic(calorie: 56,  carb: 2,  protein: 3,  fat: 4),
        73: NutiritionInformationBasic(calorie: 80,  carb: 10, protein: 3,  fat: 4),
        74: NutiritionInformationBasic(calorie: 280, carb: 36, protein: 14, fat: 10),
        75: NutiritionInformationBasic(calorie: 216, carb: 18, protein: 14, fat: 10),
        76: NutiritionInformationBasic(calorie: 280, carb: 5,  protein: 18, fat: 21),
        77: NutiritionInformationBasic(calorie: 480, carb: 15, protein: 32, fat: 35),
        78: NutiritionInformationBasic(calorie: 520, carb: 96, protein: 20, fat: 4),
        79: NutiritionInformationBasic(calorie: 316, carb: 62, protein: 12, fat: 2),
        80: NutiritionInformationBasic(calorie: 540, carb: 75, protein: 24, fat: 15),
        81: NutiritionInformationBasic(calorie: 300, carb: 18, protein: 20, fat: 16),
        82: NutiritionInformationBasic(calorie: 64,  carb: 3,  protein: 6,  fat: 3),
        83: NutiritionInformationBasic(calorie: 180, carb: 15, protein: 9,  fat: 8),
        84: NutiritionInformationBasic(calorie: 250, carb: 25, protein: 15, fat: 10),
        85: NutiritionInformationBasic(calorie: 300, carb: 9,  protein: 21, fat: 21),
        86: NutiritionInformationBasic(calorie: 525, carb: 25, protein: 45, fat: 28),
        87: NutiritionInformationBasic(calorie: 260, carb: 56, protein: 6,  fat: 0),
        88: NutiritionInformationBasic(calorie: 420, carb: 75, protein: 15, fat: 9),
        89: NutiritionInformationBasic(calorie: 360, carb: 30, protein: 24, fat: 16),
        90: NutiritionInformationBasic(calorie: 240, carb: 31, protein: 10, fat: 8),
        91: NutiritionInformationBasic(calorie: 232, carb: 16, protein: 6,  fat: 16),
        92: NutiritionInformationBasic(calorie: 870, carb: 120,protein: 24, fat: 36),
        93: NutiritionInformationBasic(calorie: 420, carb: 63, protein: 21, fat: 7),
        94: NutiritionInformationBasic(calorie: 455, carb: 70, protein: 25, fat: 11),
        95: NutiritionInformationBasic(calorie: 216, carb: 5,  protein: 24, fat: 12),
        96: NutiritionInformationBasic(calorie: 76,  carb: 14, protein: 2,  fat: 1),
        97: NutiritionInformationBasic(calorie: 390, carb: 75, protein: 12, fat: 3),
        98: NutiritionInformationBasic(calorie: 500, carb: 60, protein: 10, fat: 24),
        99: NutiritionInformationBasic(calorie: 216, carb: 4,  protein: 24, fat: 13)
    ]
}


struct NutritionInformationService {
    
    static func getNutritionInformation(classId: Int, classLabel: String, gram: Double) -> NutritionInformation {
        let nutritionFor100 = NutritionData.nutritionInfoFor100Gr[classId] ?? 
            NutiritionInformationBasic(calorie: 0, carb: 0, protein: 0, fat: 0)
        
        let proportion: Double = gram / 100.0
        let calorie: Double = Double(nutritionFor100.calorie) * proportion
        let carb: Double = Double(nutritionFor100.carb) * proportion
        let protein: Double = Double(nutritionFor100.protein) * proportion
        let fat: Double = Double(nutritionFor100.fat) * proportion
        
        return NutritionInformation(
            classId,
            classLabel,
            gram,
            calorie,
            carb,
            protein,
            fat
        )
    }

    static func calculateFromFoodMeasurements(foodMeasurements: [FoodMeasurement]) -> [NutritionInformation] {
        var nutritionInformations: [NutritionInformation] = []
        for foodMeasurement in foodMeasurements {
            let nutritionInformation = getNutritionInformation(classId: foodMeasurement.classId, classLabel: foodMeasurement.classLabel, gram: foodMeasurement.gram)
            nutritionInformations.append(nutritionInformation)
        }
        return nutritionInformations
    }
    
    static func getNutritionInformationOnePortion(classId : Int, classLabel : String) -> NutritionInformation {
        let gr = NutritionData.portionSizeInGrams[classId]!
        let info = NutritionData.nutritionInfoForOnePorsion[classId]!
        
        return NutritionInformation(classId, classLabel, gr, info.calorie, info.carb, info.protein, info.fat)
    }

    static func calculateFromDetectedFoods(detectedFoods: [FoodRecognitionViewModel.DetectedFood]) -> [NutritionInformation] {
        var nutritionInformations: [NutritionInformation] = []
        for detectedFood in detectedFoods {
            let nutritionInformation = getNutritionInformationOnePortion(classId: detectedFood.classId, classLabel: detectedFood.classLabel)
            nutritionInformations.append(nutritionInformation)
        }
        return nutritionInformations
    }
}
