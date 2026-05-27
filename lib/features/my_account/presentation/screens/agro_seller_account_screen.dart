import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/my_account_screen.dart';
import 'package:tradologie_app/injection_container.dart';

class AgroSellerAccountScreen extends StatefulWidget {
  const AgroSellerAccountScreen({super.key});

  @override
  State<AgroSellerAccountScreen> createState() => _AgroSellerAccountScreenState();
}

class _AgroSellerAccountScreenState extends State<AgroSellerAccountScreen> {
  final SecureStorageService _storage = SecureStorageService();

  String _name = '';
  String _userId = '';
  CompanyDetails? _companyDetails;

  @override
  void initState() {
    super.initState();
    _loadHeader();
  }

  Future<void> _loadHeader() async {
    final storedName = Constants.name;
    final userId = await _storage.read(AppStrings.userId);
    final vendorId = await _storage.read(AppStrings.vendorId);

    if (!mounted) return;

    setState(() {
      _name = storedName.trim();
      _userId = (userId ?? '').trim().isNotEmpty
          ? (userId ?? '').trim()
          : (vendorId ?? '').trim();
    });
  }

  int _profileCompletionPercent(CompanyDetails? d) {
    if (d == null) return 0;
    final checks = <bool>[
      (d.vendorName ?? '').trim().isNotEmpty,
      (d.companyName ?? '').trim().isNotEmpty,
      (d.companyType ?? '').trim().isNotEmpty,
      (d.companyPanNo ?? '').trim().isNotEmpty,
      (d.companyIec ?? '').trim().isNotEmpty,
      (d.countryId ?? 0) != 0,
      (d.stateId ?? 0) != 0,
      (d.cityId ?? 0) != 0,
      (d.address ?? '').trim().isNotEmpty,
      (d.zipCode ?? '').trim().isNotEmpty,
      (d.dateOfIncorporation ?? '').trim().isNotEmpty,
    ];
    final completed = checks.where((x) => x).length;
    return ((completed / checks.length) * 100).round().clamp(0, 100);
  }

  void _openSection(int tabIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyAccountScreen(initialTabIndex: tabIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percent = _profileCompletionPercent(_companyDetails);

    return BlocProvider(
      create: (_) => sl<MyAccountCubit>()..companyDetails(NoParams()),
      child: BlocListener<MyAccountCubit, MyAccountState>(
        listenWhen: (previous, current) => current is CompanyDetailsSuccess,
        listener: (_, state) {
          if (state is CompanyDetailsSuccess) {
            setState(() => _companyDetails = state.data);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'My Account',
              style: GoogleFonts.afacad(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _HeaderCard(
                name: _name.isEmpty ? '—' : _name,
                userId: _userId.isEmpty ? '—' : _userId,
              ),
              const SizedBox(height: 12),
              _CompletionCard(
                percent: percent,
                onCompleteProfile: () => _openSection(2),
              ),
              const SizedBox(height: 18),
              Text(
                'Account Sections',
                style: GoogleFonts.afacad(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF576680),
                ),
              ),
              const SizedBox(height: 10),
              _SectionTile(
                title: 'Login Control',
                onTap: () => _openSection(0),
              ),
              _SectionTile(
                title: 'Information',
                onTap: () => _openSection(1),
              ),
              _SectionTile(
                title: 'Company Details',
                onTap: () => _openSection(2),
              ),
              _SectionTile(
                title: 'Documents',
                onTap: () => _openSection(3),
              ),
              _SectionTile(
                title: 'Authorized Person',
                onTap: () => _openSection(4),
              ),
              _SectionTile(
                title: 'Legal Documents',
                onTap: () => _openSection(5),
              ),
              _SectionTile(
                title: 'Bank Details',
                onTap: () => _openSection(6),
              ),
              _SectionTile(
                title: 'Selling Location',
                onTap: () => _openSection(7),
              ),
              _SectionTile(
                title: 'Bulk & Retail',
                onTap: () => _openSection(8),
              ),
              _SectionTile(
                title: 'Membership Type',
                onTap: () => _openSection(9),
              ),
              _SectionTile(
                title: 'Commodity',
                onTap: () => _openSection(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String name;
  final String userId;

  const _HeaderCard({
    required this.name,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.afacad(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'User ID: $userId',
                  style: GoogleFonts.afacad(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final int percent;
  final VoidCallback onCompleteProfile;

  const _CompletionCard({
    required this.percent,
    required this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context) {
    final value = (percent.clamp(0, 100)) / 100;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Complete your Profile',
                style: GoogleFonts.afacad(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '60 %',
                style: GoogleFonts.afacad(
                  fontSize: 25,
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Positioned.fill(
                  child: LinearProgressIndicator(
                    value: 0.6, // 60%
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              const SizedBox(width: 8),

            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add your details to unlock all features',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF576680),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCompleteProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    elevation: 0,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    textAlign: TextAlign.start,
                    'Complete',
                    style: GoogleFonts.afacad(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )




    );
  }
}

class _SectionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SectionTile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: GoogleFonts.afacad(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      ),
    );
  }
}

