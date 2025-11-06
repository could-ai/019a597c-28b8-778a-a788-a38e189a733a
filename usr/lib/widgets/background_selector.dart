import 'package:flutter/material.dart';

class BackgroundSelector extends StatelessWidget {
  final String? selectedBackground;
  final Function(String) onBackgroundSelected;

  const BackgroundSelector({
    super.key,
    required this.selectedBackground,
    required this.onBackgroundSelected,
  });

  @override
  Widget build(BuildContext context) {
    final backgrounds = [
      {
        'id': 'office',
        'name': 'Biuro',
        'description': 'Profesjonalne tło biurowe',
        'gradient': [Color(0xFFDCE1E6), Color(0xFFB4BCC4)],
      },
      {
        'id': 'studio',
        'name': 'Studio',
        'description': 'Czyste białe tło',
        'gradient': [Color(0xFFFFFFFF), Color(0xFFF0F0F0)],
      },
      {
        'id': 'business',
        'name': 'Biznesowe',
        'description': 'Eleganckie granatowe tło',
        'gradient': [Color(0xFF19234B), Color(0xFF374B7D)],
      },
      {
        'id': 'elegant',
        'name': 'Eleganckie',
        'description': 'Ciemne szare tło',
        'gradient': [Color(0xFF282830), Color(0xFF3C3C46)],
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: backgrounds.length,
        itemBuilder: (context, index) {
          final background = backgrounds[index];
          final isSelected = selectedBackground == background['id'];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onBackgroundSelected(background['id'] as String),
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      // Background gradient preview
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: background['gradient'] as List<Color>,
                          ),
                        ),
                      ),
                      // Label overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                background['name'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                background['description'] as String,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Selected indicator
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
