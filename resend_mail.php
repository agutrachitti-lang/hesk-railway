<?php

function hesk_resend_send($to, $cc, $subject, $message, $html_message, $tracking_ID = null)
{
    $api_key = getenv('RESEND_API_KEY');

    if (!$api_key) {
        throw new Exception('RESEND_API_KEY no está configurada.');
    }

    $recipients = [];

    foreach ($to as $email) {
        $recipients[] = trim($email);
    }

    foreach ($cc as $email) {
        $recipients[] = trim($email);
    }

    $payload = [
        'from' => 'OdinTech Ticket <ticket@odintech.com.ar>',
        'to' => $recipients,
        'subject' => $subject,
        'html' => $html_message,
        'text' => $message
    ];

    $ch = curl_init('https://api.resend.com/emails');

    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => [
            'Authorization: Bearer ' . $api_key,
            'Content-Type: application/json'
        ],
        CURLOPT_POSTFIELDS => json_encode($payload),
        CURLOPT_TIMEOUT => 30
    ]);

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    if ($response === false) {
        $error = curl_error($ch);
        curl_close($ch);
        throw new Exception($error);
    }

    curl_close($ch);

    if ($http_code < 200 || $http_code >= 300) {
        throw new Exception(
            'Resend HTTP ' . $http_code . ': ' . $response
        );
    }

    return true;
}
