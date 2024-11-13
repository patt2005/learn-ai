class OnboardingInfo {
  final String imageAssetPath;
  final String title;
  final String buttonText;
  final String description;

  OnboardingInfo({
    required this.imageAssetPath,
    required this.title,
    required this.buttonText,
    required this.description,
  });
}

List<OnboardingInfo> onboardingPagesInfo = [
  OnboardingInfo(
    imageAssetPath: "images/onboarding/onboarding_image1.png",
    title: "Bine ați venit la LearnAI!",
    buttonText: "Continuă",
    description:
        "Alătură-te nouă într-o aventură plină de distracție în care învățarea cuvintelor noi este interesantă și ușoară. Cu jocuri bazate pe inteligență artificială și lecții interactive, vei deveni un maestru în cel mai scurt timp!",
  ),
  OnboardingInfo(
    imageAssetPath: "images/onboarding/onboarding_image2.png",
    title: "Prietenul tău AI este aici să te ajute!",
    buttonText: "Continuă",
    description:
        "Fă cunoștință cu inteligența ta artificială prietenoasă care te va ghida prin exerciții distractive, te va provoca cu puzzle-uri de cuvinte și îți va recompensa progresul pe parcurs!",
  ),
  OnboardingInfo(
    imageAssetPath: "images/onboarding/onboarding_image3.png",
    title: "Dezvoltă-ți vocabularul!",
    buttonText: "Începe!",
    description:
        "Învață, joacă-te și descoperă zilnic cuvinte noi. Urmărește-ți progresul, deblochează realizări și vezi cât de repede îți crește vocabularul!",
  ),
];
