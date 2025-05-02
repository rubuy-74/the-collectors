import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:usettle/view/common/pages/general.dart';
import 'package:usettle/view/tabs/tab_list.dart';
import 'package:usettle/view/tabs/tab_screen.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});


  @override
  State<StatefulWidget> createState() => _TabsPageState();
}

class _TabsPageState extends GeneralPageViewState<TabsPage>{
  List<Transaction> generateTransactions() {
    final now = DateTime.now();
    final random = Random();
    final pastDays = 30;

    return List.generate(20, (index) {
      final dayOffset = random.nextInt(pastDays);
      final hourOffset = random.nextInt(24);
      final minuteOffset = random.nextInt(60);
      final secondOffset = random.nextInt(60);
      final isPositive = random.nextBool();
      final quantity = (random.nextDouble() * 200 * (isPositive ? 1 : -1)).toStringAsFixed(2);

      final descriptions = [
        "Supermercado Continente",
        "Almoço com amigos",
        "Conta de eletricidade",
        "Renda do apartamento",
        "Bilhetes de cinema",
        "Livro novo",
        "Gasolina",
        "Café da manhã",
        "Transporte público",
        "Consulta médica",
        "Farmácia",
        "Roupa nova",
        "Corte de cabelo",
        "Doação para caridade",
        "Curso online",
        "Assinatura de streaming",
        "Jantar de aniversário",
        "Pequeno almoço",
        "Reparação do carro",
        "Viagem de fim de semana",

        // Groceries & Food
        "Supermercado Pingo Doce",
        "Mercado Municipal",
        "Talho Central",
        "Peixaria da Esquina",
        "Padaria Portuguesa",
        "Frutaria do Bairro",
        "Refeição no restaurante O Cantinho",
        "Pizza para levar",
        "Sushi Takeaway",
        "Gelado artesanal",
        "Encomenda de comida online (Uber Eats)",
        "Compras no Celeiro (produtos naturais)",

        // Utilities & Housing
        "Conta da água (SMAS)",
        "Fatura da luz (EDP)",
        "Gás natural (Galp)",
        "Serviços de internet e TV (NOS)",
        "Mensalidade do condomínio",
        "Reparação canalização",
        "Pintura da sala",
        "Compra de material de limpeza",

        // Entertainment & Leisure
        "Bilhetes para o concerto na Altice Arena",
        "Entradas no Jardim Zoológico",
        "Mensalidade do ginásio",
        "Aluguer de filme online",
        "Ida ao cinema no Dolce Vita",
        "Livro comprado na Bertrand",
        "Jogo de tabuleiro",
        "Visita ao Museu Nacional de Grão Vasco",

        // Transportation
        "Gasolina no Intermarché",
        "Portagem A1",
        "Bilhete de comboio (CP)",
        "Passe mensal (SMTUC)",
        "Viagem de autocarro",
        "Serviço de táxi",
        "Aluguer de bicicleta GIRA",
        "Estacionamento no centro",

        // Shopping & Personal Care
        "Roupa na Zara",
        "Sapatos na Seaside",
        "Cosméticos na Sephora",
        "Corte de cabelo no barbeiro",
        "Manicure e pedicure",
        "Óculos novos na MultiOpticas",
        "Jóias na Ourivesaria Portugal",

        // Health & Wellness
        "Consulta no médico de família",
        "Medicamentos na farmácia",
        "Suplementos alimentares",
        "Sessão de fisioterapia",
        "Aula de yoga",

        // Education & Professional Development
        "Mensalidade da faculdade",
        "Curso de línguas online",
        "Workshop profissional",
        "Compra de material de estudo",

        // Gifts & Donations
        "Presente de aniversário",
        "Oferta para o Natal",
        "Doação à Cruz Vermelha",
        "Contribuição para projeto social",

        // Other
        "Levantamento Multibanco",
        "Depósito bancário",
        "Taxas bancárias",
        "Seguro do carro",
        "Seguro de saúde",
        "Impostos",
        "Propinas escolares",
        "Pensão de alimentos",
        "Pequenos trabalhos ocasionais",
        "Venda de artigos usados online",
      ];

      return Transaction(
        time: now.subtract(Duration(days: dayOffset, hours: hourOffset, minutes: minuteOffset, seconds: secondOffset)),
        description: descriptions[index % descriptions.length],
        quantity: double.parse(quantity),
      );
    });
  }

  List<String> generateNames({int count = 20}) {
    final random = Random();
    const firstNames = [
      "Maria", "João", "Ana", "Pedro", "Sofia", "Miguel", "Beatriz", "Ricardo",
      "Carolina", "Tiago", "Inês", "André", "Mariana", "Daniel", "Laura", "Rui",
      "Francisca", "Manuel", "Alice", "Vasco"
    ];
    const lastNames = [
      "Silva", "Santos", "Ferreira", "Pereira", "Oliveira", "Costa", "Rodrigues",
      "Martins", "Alves", "Teixeira", "Carvalho", "Gomes", "Pinto", "Mendes",
      "Sousa", "Nunes", "Moreira", "Vieira", "Marques", "Machado"
    ];
    final generatedNames = <String>[];

    while (generatedNames.length < count) {
      final firstName = firstNames[random.nextInt(firstNames.length)];
      final lastName = lastNames[random.nextInt(lastNames.length)];
      final fullName = "$firstName $lastName";
      if (!generatedNames.contains(fullName)) {
        generatedNames.add(fullName);
      }
    }

    return generatedNames;
  }

  List<Transaction> getRandomTransactions({required List<Transaction> transactions,required int count}) {
    final length = transactions.length;
    final random = Random();
    return List.generate(count, (_) => transactions[random.nextInt(length)]);

  }

  List<CustomTab> generateTabs() {
    List<Transaction> transactions = generateTransactions();
    List<String> names = generateNames(count: 12);
    final random = Random();

    return names.map((e) =>
      CustomTab(
          name: names[random.nextInt(names.length)],
          transactions: getRandomTransactions(transactions: transactions, count: 7))
    ).toList();
  }


  @override
  Widget getBody(BuildContext context) {
    return TabSelectionPage(initialTabs: generateTabs());
  }

  @override
  String? getTitle() {
    return "Contas";
  }
}
