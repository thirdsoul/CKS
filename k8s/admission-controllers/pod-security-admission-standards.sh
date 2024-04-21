










#DEFINED AT NAMESPACE LEVEL
# MODE must be one of `enforce`, `audit`, or `warn`.

    # enforce	Policy violations will cause the pod to be rejected.
    # audit	Policy violations will trigger the addition of an audit annotation to the event recorded in the audit log, but are otherwise allowed.
    # warn	Policy violations will trigger a user-facing warning, but are otherwise allowed.

# LEVEL must be one of `privileged`, `baseline`, or `restricted`.

    # Privileged	Unrestricted policy, providing the widest possible level of permissions. This policy allows for known privilege escalations.
    # Baseline	Minimally restrictive policy which prevents known privilege escalations. Allows the default (minimally specified) Pod configuration.
    # Restricted	Heavily restricted policy, following current Pod hardening best practices.

# pod-security.kubernetes.io/<MODE>: <LEVEL>

kubectl label node worker pod-security.kubernetes.io/enforce: baseline
kubectl label node worker pod-security.kubernetes.io/audit: restricted


