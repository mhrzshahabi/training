package com.nicico.training.utility;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.enumeration.ActionType;
import lombok.RequiredArgsConstructor;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.Locale;

@Component
@RequiredArgsConstructor
public class AuthorizationUtil {

    private final ResourceBundleMessageSource messageSource;

    public String getStandardPermissionKey(String entityName, String actionTypeStr) {

        ActionType actionType = ActionType.valueOf(actionTypeStr);
        switch (actionType) {

            case Get:
            case List:
            case Search:
                return entityName + "_R";
            case Create:
            case CreateAll:
                return entityName + "_C";
            case Update:
            case UpdateAll:
                return entityName + "_U";
            case Delete:
            case DeleteAll:
                return entityName + "_D";
            default:
                return entityName;
        }
    }

    public void checkStandardPermission(String entityName, String actionTypeStr) {

        Locale locale = LocaleContextHolder.getLocale();
        String standardPermissionKey = getStandardPermissionKey(entityName, actionTypeStr);
        if (StringUtils.hasText(standardPermissionKey))
            throw new TrainingException(TrainingException.ErrorType.Forbidden, "", messageSource.getMessage("validator.permission.action-type.is.empty", null, locale));
        if (!SecurityUtil.hasAuthority(standardPermissionKey))
            throw new TrainingException(TrainingException.ErrorType.Unauthorized, "", messageSource.getMessage("validator.permission.access-denied", new Object[]{standardPermissionKey}, locale));
    }

    public void checkStandardPermission(String permissionKey) {

        Locale locale = LocaleContextHolder.getLocale();
        if (!SecurityUtil.hasAuthority(permissionKey))
            throw new TrainingException(TrainingException.ErrorType.Unauthorized, "", messageSource.getMessage("validator.permission.access-denied", new Object[]{permissionKey}, locale));
    }
}
