# Release Checklist v1.0.0

## Pre-Release

### Code Quality
- [x] All features implemented and tested
- [x] No critical bugs
- [x] Code reviewed
- [x] Documentation updated
- [x] README.md updated
- [x] CHANGELOG.md created
- [x] Comments and cleanup done

### Configuration
- [x] Version number updated (pubspec.yaml)
- [x] Build number incremented
- [x] Release notes prepared
- [x] Screenshots captured
- [x] Build scripts created

### Testing
- [ ] Manual testing on multiple devices
- [ ] Android 5.0+ compatibility tested
- [ ] Different screen sizes tested
- [ ] Landscape/portrait modes tested
- [ ] Hardware keyboard tested
- [ ] SSH connection tested
- [ ] Password authentication tested
- [ ] SSH key authentication tested
- [ ] Settings persistence tested
- [ ] Theme changes tested
- [ ] Memory leaks checked
- [ ] Battery usage acceptable

### Build
- [ ] Debug build successful
- [ ] Release build successful
- [ ] APK size within target (< 15MB)
- [ ] App bundle created
- [ ] ProGuard rules working
- [ ] No build warnings

### Security
- [x] No hardcoded secrets
- [x] Credentials properly stored
- [x] Network security config set
- [x] No sensitive data in logs
- [x] SSH keys encrypted

### Documentation
- [x] README.md complete
- [x] QUICKSTART.md created
- [x] CHANGELOG.md created
- [x] Release notes prepared
- [x] Inline code comments added
- [x] License file present

---

## Release Process

### Step 1: Final Build
```bash
./build_release.sh
```

### Step 2: Verify Build
- [ ] Install APK on test device
- [ ] Verify all features work
- [ ] Check performance
- [ ] Verify no crashes

### Step 3: Create Git Tag
```bash
git tag -a v1.0.0 -m "Release v1.0.0 - Initial Release"
git push origin v1.0.0
```

### Step 4: Create GitHub Release
- [ ] Go to GitHub → Releases → Draft new release
- [ ] Select tag: v1.0.0
- [ ] Release title: v1.0.0 - Initial Release
- [ ] Copy RELEASE-v1.0.0.md content
- [ ] Upload APK file
- [ ] Upload AAB file (optional)
- [ ] Upload CHANGELOG.md
- [ ] Set as latest release
- [ ] Publish release

### Step 5: Distribution
- [ ] Share release link
- [ ] Update website/landing page
- [ ] Social media announcement
- [ ] Update documentation site

---

## Post-Release

### Immediate
- [ ] Test download link works
- [ ] Verify release notes display correctly
- [ ] Check all files uploaded
- [ ] Test APK installation

### Monitoring
- [ ] Monitor GitHub issues
- [ ] Watch for crash reports
- [ ] Gather user feedback
- [ ] Track downloads

### Documentation
- [ ] Update roadmap
- [ ] Plan next release features
- [ ] Document any hotfixes needed

---

## Play Store Release (Optional)

### Pre-Upload
- [ ] Create developer account
- [ ] Pay registration fee ($25)
- [ ] Prepare store listing
- [ ] Prepare screenshots (phone, tablet)
- [ ] Prepare feature graphic
- [ ] Write description
- [ ] Prepare privacy policy

### Store Listing
- [ ] App title: SSH Tool
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)
- [ ] Screenshots (2-8 per device type)
- [ ] Feature graphic (1024x500)
- [ ] App icon (512x512)
- [ ] Category: Tools
- [ ] Content rating questionnaire
- [ ] Privacy policy URL

### Upload
- [ ] Upload AAB file
- [ ] Fill store listing
- [ ] Set pricing (Free)
- [ ] Select countries
- [ ] Add privacy policy
- [ ] Submit for review

### After Approval
- [ ] Verify live on store
- [ ] Test install from store
- [ ] Monitor ratings and reviews
- [ ] Respond to user feedback

---

## F-Droid Release (Optional)

- [ ] Check F-Droid requirements
- [ ] Prepare metadata
- [ ] Create merge request
- [ ] Wait for inclusion

---

## Rollback Plan

If critical issues found:
1. [ ] Mark release as pre-release
2. [ ] Delete release
3. [ ] Create hotfix branch
4. [ ] Fix issue
5. [ ] Release v1.0.1

---

## Contact Information

- **Developer**: Your Name
- **Email**: your.email@example.com
- **GitHub**: https://github.com/yourusername/sshtool
- **Issues**: https://github.com/yourusername/sshtool/issues

---

## Notes

- Keep this checklist for future releases
- Update checklist as process evolves
- Document any issues encountered
- Save time estimates for planning

---

**Release Date**: 2026-04-24
**Release Manager**: [Your Name]
**Status**: Ready for Testing ⚠️
