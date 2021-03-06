package com.nicico.training;

import org.apache.commons.codec.binary.Base64;

public class TokenTest {

    public static void main(String[] args) {
        String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyUm9sZXMiOiJyZXFleHBlcnQiLCJ1c2VyR3JvdXBzIjoiR1JPVVBfQURNSU4iLCJhdWQiOlsiVHJhaW5pbmdEZXZSZXNvdXJjZUlkIiwiT0F1dGhSZXNvdXJjZUlkIl0sInVzZXJfbmFtZSI6InJpYWhpIiwic2NvcGUiOlsidXNlcl9pbmZvIl0sInVzZXJGdWxsTmFtZSI6Itiy2YfYsdinINix24zYp9it24wgIiwiZXhwIjoxNTYyNDQ3ODY2LCJhdXRob3JpdGllcyI6WyJjX3NraWxsX2dyb3VwIiwicl9qb2IiLCJ1X3BheW1lbnRPcHRpb24iLCJkX2RhaWx5UmVwb3J0QmFuZGFyQWJiYXMiLCJkX3RvemluU2FsZXMiLCJkX3NraWxsX2dyb3VwIiwicl9ib2xJdGVtIiwidV90ZWFjaGVyIiwiY19ib2xIZWFkZXIiLCJyX2NvbnRhY3RBY2NvdW50Iiwicl9za2lsbFN0YW5kYXJkU3ViQ2F0ZWdvcnkiLCJ1X3VuaXQiLCJyX2JhbmsiLCJyX3NraWxsTGV2ZWwiLCJkX3N5bGxhYnVzIiwiY19jb250cmFjdEFkZGVuZHVtIiwidV9wb3J0IiwiY19za2lsbFN0YW5kYXJkU3ViQ2F0ZWdvcnkiLCJ1X3NraWxsU3RhbmRhcmRTdWJDYXRlZ29yeSIsInVfY291bnRyeSIsInVfc2tpbGxTdGFuZGFyZENhdGVnb3J5IiwiZF9za2lsbCIsInJfc2tpbGxfZ3JvdXAiLCJ1X3NraWxsX2dyb3VwIiwicl90ZWFjaGVyIiwiY19kYWlseVJlcG9ydEJhbmRhckFiYmFzIiwidV9zeWxsYWJ1cyIsImRfYm9sSGVhZGVyIiwicl9ib2xIZWFkZXIiLCJyX2NhdGVnb3J5IiwiZF9iYW5rIiwiZF9jb250cmFjdFNoaXBtZW50IiwiY19ib2xJdGVtIiwiY190ZWFjaGVyIiwiY19za2lsbExldmVsIiwiZF9jb250YWN0IiwiZF9za2lsbFN0YW5kYXJkU3ViQ2F0ZWdvcnkiLCJ1X2Nvc3QiLCJyX3BheW1lbnRPcHRpb24iLCJ1X2dyb3VwcyIsImRfc2tpbGxTdGFuZGFyZCIsImNfc2tpbGxTdGFuZGFyZCIsImNfcGF5bWVudE9wdGlvbiIsImNfdG96aW4iLCJkX2NhdGVnb3J5IiwiY19yYXRlIiwicl9kYWlseVJlcG9ydEJhbmRhckFiYmFzIiwidV9zdWJfQ2F0ZWdvcnkiLCJkX3NraWxsU3RhbmRhcmRDYXRlZ29yeSIsImRfdW5pdCIsInJfc2tpbGwiLCJjX3N5bGxhYnVzIiwidV9qb2IiLCJjX2NvbnRyYWN0IiwiZF9wb3J0IiwiZF9za2lsbExldmVsIiwicl9zeWxsYWJ1cyIsImNfY29zdCIsInJfY291cnNlIiwidV9jYXRlZ29yeSIsInVfc2tpbGxMZXZlbCIsInJfY29udHJhY3QiLCJkX2ludm9pY2UiLCJyX3JhdGUiLCJkX2NvbnRhY3RBY2NvdW50IiwiZF9ib2xJdGVtIiwiZF90ZWFjaGVyIiwidV9jb250cmFjdFNoaXBtZW50IiwidV9yYXRlIiwiY19qb2IiLCJjX3VuaXQiLCJjX3BvcnQiLCJ1X3RvemluU2FsZXMiLCJyX3RvemluU2FsZXMiLCJkX3RvemluIiwicl9jb3N0IiwiY19pbnZvaWNlIiwicl9jb250cmFjdFNoaXBtZW50Iiwicl9za2lsbFN0YW5kYXJkR3JvdXAiLCJyX3RvemluIiwiY19zdWJfQ2F0ZWdvcnkiLCJyX2NvbnRhY3QiLCJjX2NhdGVnb3J5IiwidV9za2lsbFN0YW5kYXJkIiwidV90b3ppbiIsImNfc2tpbGxTdGFuZGFyZEdyb3VwIiwiY19jb3VudHJ5IiwiZF9ncm91cHMiLCJjX2NvdXJzZSIsInJfc2tpbGxTdGFuZGFyZENhdGVnb3J5IiwiY190b3ppblNhbGVzIiwicl9ncm91cHMiLCJkX2NvbnRyYWN0QWRkZW5kdW0iLCJ1X2JvbEhlYWRlciIsInVfY29udHJhY3QiLCJ1X2NvdXJzZSIsInJfaW52b2ljZSIsImNfYmFuayIsInVfZGFpbHlSZXBvcnRCYW5kYXJBYmJhcyIsImNfY29udHJhY3RTaGlwbWVudCIsImRfY29zdCIsImRfcGF5bWVudE9wdGlvbiIsImRfY29udHJhY3QiLCJ1X2JhbmsiLCJyX3VuaXQiLCJkX3N1Yl9DYXRlZ29yeSIsInVfc2tpbGxTdGFuZGFyZEdyb3VwIiwiZF9qb2IiLCJkX3JhdGUiLCJ1X2ludm9pY2UiLCJjX3NraWxsU3RhbmRhcmRDYXRlZ29yeSIsImNfc2tpbGwiLCJkX2NvdW50cnkiLCJyX3BvcnQiLCJkX3NraWxsU3RhbmRhcmRHcm91cCIsInVfY29udGFjdCIsInVfc2tpbGwiLCJ1X2JvbEl0ZW0iLCJyX2NvdW50cnkiLCJjX2dyb3VwcyIsInVfY29udHJhY3RBZGRlbmR1bSIsImNfY29udGFjdEFjY291bnQiLCJyX2NvbnRyYWN0QWRkZW5kdW0iLCJ1X2NvbnRhY3RBY2NvdW50IiwiY19jb250YWN0IiwiZF9jb3Vyc2UiLCJyX3NraWxsU3RhbmRhcmQiLCJyX3N1Yl9DYXRlZ29yeSJdLCJqdGkiOiJkNWQ4YmUyYS1mZWY5LTQzYjMtYjU3ZC03MTgwM2Q3ZDkxNGEiLCJjbGllbnRfaWQiOiJUcmFpbmluZ0RldkNsaWVudElkIn0.UNTErhsRS-rYcAVPrsuFguPMvWmraCO_IwFXTh93BMe5R2hk7NDFHyxRKchloQJDS08owF08GQPX0IA8n4JdE_mrmK94z4zKWmprWN2zoOcnnIsh5wRUvZ4bD9V802yPJrNmSQK7uoYFhr5ifKP0sybt6FT6yzJ9O2X0JZNHBsjWOJx6T1-toOhuEb39NxLMz41_G9q2NLFvDrJwv06L4nZ8sG0WlJBt-nM5Y8ciUn43gnDd1Pw73J71uWgbDdhS1vOX4dVRfUcgwL10HXlz95YqVTq3mrwb0DQ6g7U-1TeCW2wUCkrAHfcrrPHMgFSQr99vi5_UhYwcZX2zA_1vYA";

        System.out.println("--------------- Decode JWT ---------------");
        System.out.println("JWT: " + jwtToken);

        String[] jwtTokenSplit = jwtToken.split("\\.");
        String base64EncodedHeader = jwtTokenSplit[0];
        String base64EncodedBody = jwtTokenSplit[1];
        String base64EncodedSignature = jwtTokenSplit[2];

        Base64 base64Url = new Base64(true);

        System.out.println("--------------- JWT Header ---------------");
        String header = new String(base64Url.decode(base64EncodedHeader));
        System.out.println("JWT Header: " + header);


        System.out.println("--------------- JWT Body ---------------");
        String body = new String(base64Url.decode(base64EncodedBody));
        System.out.println("JWT Body: " + body);

        System.out.println("--------------- JWT Signature ---------------");
        System.out.println("JWT Signature: " + base64EncodedSignature);
    }
}
