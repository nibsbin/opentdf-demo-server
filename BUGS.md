# BUGS

## Case Sensitivity Nightmare

I just wasted so much time debugging why the USAF demo attributes weren't working. It turns out the OpenTDF platform silently normalizes all attributes to lowercase, but doesn't warn you if your policy definitions use mixed case!

The fixtures had `flight_RCH2532102` (CamelCase/Uppercase), but the system was looking for `flight_rch2532102`. Because of this silent normalization, the policy engine couldn't match the attributes, leading to cryptic `PermissionDenied` errors or just failing to apply the right access controls.

Why does it allow me to define mixed-case attributes in the YAML if it's just going to mangle them internally and then fail to match them? This is incredibly frustrating!

I had to go through `policy_fixtures.yaml` and `keycloak_data.yaml` and manually lowercase every single attribute definition and reference to get it working.

FIX THIS or at least WARN US!
