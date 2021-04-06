

class RecipeMenuModel{
  final String title;
  final String info;
  final String image;

  RecipeMenuModel({this.title,this.image,this.info});

  static List<RecipeMenuModel> diet(){
        return <RecipeMenuModel>[
          RecipeMenuModel(
            title: "Gluten Free",
            info: "Eliminating gluten means avoiding wheat, barley, rye, and other gluten-containing grains and foods made from them (or that may have been cross contaminated).",
            image: 'images/recipeassets/diet/glutenfree.jpg'
          ),
          RecipeMenuModel(
              title: "Ketogenic",
              info: "The keto diet is based more on the ratio of fat, protein, and carbs in the diet rather than specific ingredients. Generally speaking, high fat, protein-rich foods are acceptable and high carbohydrate foods are not.",
              image: 'images/recipeassets/diet/ketogenic.png'
          ),
          RecipeMenuModel(
              title: "Vegetarian",
              info: "No ingredients may contain meat or meat by-products, such as bones or gelatin.",
              image: 'images/recipeassets/diet/vegetarian.jpg'
          ),
          RecipeMenuModel(
              title: "Lacto-Vegetarian",
              info: "All ingredients must be vegetarian and none of the ingredients can be or contain egg.",
              image: 'images/recipeassets/diet/lacto_vegetarian.jpg'
          ),
          RecipeMenuModel(
              title: "Ovo-Vegetarian",
              info: "All ingredients must be vegetarian and none of the ingredients can be or contain dairy.",
              image: 'images/recipeassets/diet/ovo_vegetarian.jpeg'
          ),
          RecipeMenuModel(
              title: "Vegan",
              info: "No ingredients may contain meat or meat by-products, such as bones or gelatin, nor may they contain eggs, dairy, or honey.",
              image: 'images/recipeassets/diet/vegan.jpg'
          ),
          RecipeMenuModel(
              title: "Pescetarian",
              info: "Everything is allowed except meat and meat by-products - some pescetarians eat eggs and dairy, some do not.",
              image: 'images/recipeassets/diet/pescetarian.jpeg'
          ),
          RecipeMenuModel(
              title: "Paleo",
              info: "Allowed ingredients include meat (especially grass fed), fish, eggs, vegetables, some oils (e.g. coconut and olive oil), and in smaller quantities, fruit, nuts, and sweet potatoes. We also allow honey and maple syrup (popular in Paleo desserts, but strict Paleo followers may disagree). Ingredients not allowed include legumes (e.g. beans and lentils), grains, dairy, refined sugar, and processed foods.",
              image: 'images/recipeassets/diet/paleo.jpg'
          ),
          RecipeMenuModel(
              title: "Primal",
              info: "Very similar to Paleo, except dairy is allowed - think raw and full fat milk, butter, ghee, etc.",
              image: 'images/recipeassets/diet/primal.jpg'
          ),
          RecipeMenuModel(
              title: "Whole30",
              info: "Allowed ingredients include meat, fish/seafood, eggs, vegetables, fresh fruit, coconut oil, olive oil, small amounts of dried fruit and nuts/seeds. Ingredients not allowed include added sweeteners (natural and artificial, except small amounts of fruit juice), dairy (except clarified butter or ghee), alcohol, grains, legumes (except green beans, sugar snap peas, and snow peas), and food additives, such as carrageenan, MSG, and sulfites.",
              image: 'images/recipeassets/diet/whole30.jpg'
          ),
        ];
  }

  static List<RecipeMenuModel> cuisine(){
    return <RecipeMenuModel>[
      RecipeMenuModel(
        title: 'African',
        image: 'images/recipeassets/cuisine/african.png'
      ),
      RecipeMenuModel(
          title: 'American',
          image: 'images/recipeassets/cuisine/american.jpg'
      ), RecipeMenuModel(
          title: 'British',
          image: 'images/recipeassets/cuisine/british.jpg'
      ),
      RecipeMenuModel(
          title: 'Caribbean',
          image: 'images/recipeassets/cuisine/caribbean.jpg'
      ),
      RecipeMenuModel(
          title: 'Chinese',
          image: 'images/recipeassets/cuisine/chinese.jpg'
      ),
      RecipeMenuModel(
          title: 'French',
          image: 'images/recipeassets/cuisine/french.jpg'
      ),
      RecipeMenuModel(
          title: 'Indian',
          image: 'images/recipeassets/cuisine/indian.jpeg'
      ),
      RecipeMenuModel(
          title: 'Italian',
          image: 'images/recipeassets/cuisine/italian.jpeg'
      ),
      RecipeMenuModel(
          title: 'Mexican',
          image: 'images/recipeassets/cuisine/mexican.jpg'
      ),
      RecipeMenuModel(
          title: 'Middle Eastern',
          image: 'images/recipeassets/cuisine/middleeastern.jpg'
      ),
    ];
  }

  static  List<RecipeMenuModel> mealType(){
    return <RecipeMenuModel>[
      RecipeMenuModel(
        title: 'main course',
        image: 'images/recipeassets/mealtype/maincourse.jpg'
      ),
      RecipeMenuModel(
          title: 'dessert',
          image: 'images/recipeassets/mealtype/dessert.png'
      ),
      RecipeMenuModel(
          title: 'appetizer',
          image: 'images/recipeassets/mealtype/appetizer.jpg'
      ),
      RecipeMenuModel(
          title: 'salad',
          image: 'images/recipeassets/mealtype/salad.jpg'
      ),
      RecipeMenuModel(
          title: 'soup',
          image: 'images/recipeassets/mealtype/soup.jpg'
      ),
      RecipeMenuModel(
          title: 'snack',
          image: 'images/recipeassets/mealtype/snack.jpg'
      ),
      RecipeMenuModel(
          title: 'drink',
          image: 'images/recipeassets/mealtype/drink.jpg'
      )
    ];
  }
}
